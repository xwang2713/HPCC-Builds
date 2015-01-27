#!/bin/bash


usage() {
   cat << EOF
     Usage $(basename $0) options
     Options:
        -b: HPCC component branch or tag.
        -p: HPCC componet ids seperated by comma. 
           1:  Clienttools
           2:  Graphcontrol 
        -r: HPCC release version. Example, 5.0.0-1
        -u: github user. Default is hpcc-systems
        -h:  Help message
      
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
github_user=hpcc-systems

project_config_file=(
      'Project configuration'
      'clienttools.conf' 
      'graphcontrol.conf' 
)


TEMP=$(/usr/bin/getopt  b:hp:Rr: $*)
if [ $? != 0 ] ; then echo "Failure to parse commandline." >&2 ; end 1 ; fi
eval set -- "$TEMP"
while true ; do
    case "$1" in
       -b) branch="$2"
            shift 2;;
       -h) usage
            shift ;;
       -p) projects="$2"
            shift 2;;
       -R) reset=1
            shift ;;
       -r) release="$2"
            shift 2;;
       -u) github_user="$2"
            shift 2;;
       --) shift ; break ;;
       *) usage ;;
    esac
done

[ -z "$branch" ] && usage
[ -z "$release" ] && release=$branch

#echo $rootDir
. ${rootDir}/bin/common
check_distro
echo "$DISTRO $CODENAME $PKG_TYPE $ARCH"
export PKG_TYPE
export CODENAME
export github_user

if [ ! -e  ${rootDir}/bin/config/os/${CODENAME}-${ARCH}.conf  ]
then
   echo ""
   echo "Build HPCC on $DISTRO $CODENAME is not supported"
   echo ""
   exit 1
fi

[ ! -d $rootDir/workspace ] && mkdir $rootDir/workspace 
cd $rootDir/workspace
export workDir=$(pwd)

[ ! -d ${workDir}/$release ] && mkdir -p  ${workDir}/$release
export releaseDir=${workDir}/$release
cd $releaseDir

[ ! -d output ] && mkdir output
export outputDir=${workDir}/$release/output

supported_projects=$(grep "projects_all=" ${rootDir}/bin/config/os/${CODENAME}-${ARCH}.conf | cut -d'=' -f2)
[ "$projects" == "all" ] && projects=${supported_projects}
echo $projects | tr [','] ['\n '] | while read project 
do
   cd $releaseDir
   echo ",${supported_projects}," | grep -e ",${project}," > /dev/null 2>&1
   if [ $? -ne 0 ]
   then
       echo "Build ${display_name} on ${CODENAME} is not supported."
       continue
   fi

   . ${rootDir}/bin/config/${project_config_file[$project]}
   
   echo 
   if [ ! -e ${rootDir}/bin/build/${CODENAME}/${build_script}_cmake_options ]
   then
       echo "Build script for ${display_name} on ${CODENAME} is not supported."
       continue
   fi
   echo "Build ${display_name} ..."

   [ ! -d $project_directory ] && mkdir $project_directory
   cd $project_directory
   echo -n "Get git repository $branch ... "
   ${rootDir}/bin/github/${github_script} $branch > git.log 2>&1
   if [ $? -ne 0 ]  
   then
      echo "FAILED"
      continue
   fi
   echo "OK"

   [ -d build ] && rm -rf build
   mkdir build
   cd build
   echo -n "build ... "
   export package_directory
   export package_name_prefix
   ${rootDir}/bin/build/${build_script}  > build.log 2>&1
   if [ $? -ne 0 ]  
   then
      echo "FAILED"
      continue
   fi
   echo "OK"


done


