$curDir = split-path $myInvocation.MyCommand.path
Import-Module ${curDir}/build_common.psm1 -Force

# Sign certificate
cp -r ${SIGN_DIRECTORY} -destination ../

$eclide_dir = "${work_directory}/${release}/eclide"

# Dependent libraries from GraphControl project
$graphcontrol_directory = "${eclide_dir}/GraphControl_lib"
if ( ! (Test-Path $graphcontrol_directory ) )
{
    mkdir $graphcontrol_directory | Out-Null
}
$graphcontrol_lib =  "${gc_directory}/build/GraphControl/bin/HPCCSystemsGraphViewControl/${cmake_build_type}" 
cp ${graphcontrol_lib}/npHPCCSystemsGraphViewControl.* -destination ${graphcontrol_directory} 

# clienttools binary
$clienttools_directory = "${eclide_dir}/HPCC-Platform"
if ( ! (Test-Path $clienttools_directory ) )
{
    mkdir $clienttools_directory | Out-Null
}
cp ${ct_directory}/build/hpccsystems-clienttools*.exe -destination ${clienttools_directory}/

# ECLIDE Documentation

if ( "$release" -match "([\d]+\.[\d]+\.[\d]+).*" )
{
   $hpcc_version = $matches[1]
}
else
{
   "Cannot get HPCC version from release variable"
   exit(1)
}
cp ${DOCS_DIRECTORY}/${hpcc_version}/ECLReference.chm -destination ${eclide_dir}/ECLIDE/docs/

 
 
 

$cmd = "cmake -G 'Visual Studio 14' -DCMAKE_BUILD_TYPE=RelWithDebInfo " `
       + "-DWITH_DYNAMIC_MSVC_RUNTIME=1 " `
	   + "-DBOOST_INCLUDEDIR:PATH=${EXTERNALS2_DIRECTORY}/boost/1.60.0 " `
	   + "-DBOOST_LIBRARYDIR:PATH=${EXTERNALS2_DIRECTORY}/boost/1.60.0/lib32-msvc-14.0 " `
	   + "-DAGG_INCLUDE_DIR:PATH=${EXTERNALS2_DIRECTORY}/agg/agg-2.4 " `
	   + "-DWTL_INCLUDE_DIR:PATH=${EXTERNALS2_DIRECTORY}/wtl/9.1.5321 " `
	   + "-DBUGTRAP_INCLUDE_DIR=${EXTERNALS2_DIRECTORY}/bugtrap/6.0.0/source " `
	   + "-DGRAPHLAYOUT_INCLUDE_DIR=${eclide_dir}/GraphControl/graphlayout " `
	   + "-DGRAPHLAYOUT_LIBRARY=${eclide_dir}/GraphControl_lib/npHPCCSystemsGraphViewControl.lib " `
	   + "-DGRAPHLAYOUT_DLL=${eclide_dir}/GraphControl_lib/npHPCCSystemsGraphViewControl.dll " `
	   + "-DGRAPHVIZ_INCLUDE_DIR=${EXTERNALS2_DIRECTORY}/graphviz/2.26.3 " `
	   + "-DGSOAP_INCLUDE_DIR=${EXTERNALS2_DIRECTORY}/gsoap/2.7/gsoap " `
	   + "-DSCINTILLA_INCLUDE_DIR=${EXTERNALS2_DIRECTORY}/scintilla/scintilla " `
	   + "-DZLIB_INCLUDE_DIR=${EXTERNALS2_DIRECTORY}/zlib/1.2.3 " `
	   + "-DFREETYPE_INCLUDE_DIR_ft2build=${EXTERNALS2_DIRECTORY}/freetype2/2.4.8/include " `
       + "-DFREETYPE_INCLUDE_DIR_freetype2=${EXTERNALS2_DIRECTORY}/freetype2/2.4.8/include " `
       + "-DFREETYPE_LIBRARY=${EXTERNALS2_DIRECTORY}/freetype2/2.4.8/objs/win32/vc2015/freetype248MT.lib " `
 	   + "${eclide_dir}/ECLIDE"

"$cmd"
iex "$cmd 2>&1; `$err=`$?"
#if ( !($err) ) { exit 1 }

"Build HPCC"
build_hpcc
if ( ! ($?) ) { exit 1 }

"Copy package"
copy_package
if ( ! ($?) ) { exit 1 }

exit 0