#!/bin/bash


usage() {
   cat << EOF
     Usage $(basename $0) options
     Options:
        -b|--branch:  HPCC component branch or tag.
        -p|--project: HPCC componet ids seperated by comma. 
           1:  Platform community
           2:  Platform community with plugin
           3:  Platform enterprise
           4:  Platform enterprise with plugin
           5:  Platform internal
           6:  Platform internal with plugin
           7:  Clienttools
           8:  Graphcontrols
           9:  Ganglia-monitoring
          10:  Nagios-monitoring
          11:  Docs
        -r|--release: HPCC release version. Example, 5.0.0-1
        -h|--help:  Help message
      
EOF
   exit 1

}


###################################################################
#
# MAIN
#
###################################################################

binDir=$(dirname $0)
cd $binDir/..
rootDir=$(pwd)

branch=
projects=all
release=
reset=0

project_config_file=(
      'Project configuration'
      'community.conf' 
      'community_with_plugins.conf' 
      'enterprise.conf' 
      'enterprise_with_plugins.conf' 
      'internal.conf' 
      'internal_with_plugins.conf' 
      'clienttools.conf' 
      'graphcontrols.conf' 
      'gangliamonitoring.conf' 
      'bagiosmonitoring.conf' 
      'docs.conf' 
)


TEMP=$(/usr/bin/getopt -o b:hp:Rr: --long branch:,help,project:,release:,reset -n 'build_hpcc' -- "$@")
if [ $? != 0 ] ; then echo "Failure to parse commandline." >&2 ; end 1 ; fi
eval set -- "$TEMP"
while true ; do
    case "$1" in
       -b|--branch) branch="$2"
            shift 2;;
       -h|--help) usage
            shift ;;
       -p|--project) projects="$2"
            shift 2;;
       -R|--reset) reset=1
            shift ;;
       -r|--release) release="$2"
            shift 2;;
       --) shift ; break ;;
       *) usage ;;
    esac
done

[ -z "$release" ] && usage
[ -z "$branch" ] && branch=$release

#echo $rootDir
. ${rootDir}/bin/common
check_distro
echo "$DISTRO $CODENAME $PKG_TYPE $ARCH"

if [ ! -e  ${rootDir}/bin/config/${CODENAME}.conf  ]
then
   echo ""
   echo "Build HPCC on $DISTRO $CODENAME is not supported"
   echo ""
   exit 1
fi

[ ! -d $rootDir/workspace ] && mkdir $rootDir/workspace 
cd $rootDir/workspace
workDir=$(pwd)

[ ! -d ${workDir}/$release ] && mkdir -p  ${workDir}/$release
releaseDir=${workDir}/$release
cd $releaseDir

[ "$projects" == "all" ] && projects=$(grep "projects_all=" ${rootDir}/bin/config/${CODENAME}.conf | cut -d'=' -f2)
echo $projects | tr [','] ['\n '] | while read project 
do
  
   echo 
   echo "Build ${project_config_file[$project]} ..."

   . ${rootDir}/bin/config/${project_config_file[$project]}
   [ ! -d $project_directory ] && mkdir $project_directory
   cd $project_directory
   echo "Get git repository $branch"
   ${rootDir}/bin/github/${github_script} $branch > git.log 2>&1
   if [ $? -ne 0 ]  
   then
      "Failed to get repository $project"
      continue
   fi
   
   [ -d build ] && rm -rf build
   mkdir build
   cd build
   echo "cmake"
   ${rootDir}/bin/build/${CODENAME}/${build_script}  > cmake.log 2>&1
   if [ $? -ne 0 ]  
   then
      "Failed to run cmake $project"
      continue
   fi

   if [ "$project" != "docs" ]
   then
      echo "make package"
      make -j4 package > build.log 2>&1
      if [ $? -ne 0 ]  
      then
         "Failed to make $project"
         continue
      fi
    
      echo "copy package"
      [ ! -d ${releaseDir}/${package_directory} ] && mkdir -p ${releaseDir}/${package_directory}
      cp ${package_name_prefix}*${PKG_TYPE} ${releaseDir}/${package_directory}/
   else
      echo "make"
      make -j4 > build.log 2>&1
      if [ $? -ne 0 ]  
      then
         "Failed to make $project"
         continue
      fi
      echo "make install"
      make install > install.log 2>&1
      if [ $? -ne 0 ]  
      then
         "Failed to make install $project"
         continue
      fi
      cp ${package_name_prefix}*pdf ${releaseDir}/${package_directory}/
     
   fi
   cd $releaseDir

done


