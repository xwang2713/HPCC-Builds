$curDir = split-path $myInvocation.MyCommand.path
Import-Module ${curDir}/build_common.psm1 -Force

@"
   cmake  -G "Visual Studio 10" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DWITH_SYSTEM_BOOST=1 
		  -DBOOST_INCLUDEDIR=${EXTERNALS2_DIRECTORY}/Boost/include/boost-1_46_1 
		  -DBOOST_LIBRARYDIR=${EXTERNALS2_DIRECTORY}/Boost/lib 
		  -DGRAPHVIZSRC_DIR=${EXTERNALS2_DIRECTORY}/graphviz-2.26.3  
		  -DEXPAT_INCLUDE_DIR=${EXTERNALS2_DIRECTORY}/expat-2.0.1 
		  -DEXPAT_LIBRARY=${EXTERNALS2_DIRECTORY}/expat-2.0.1   
		  -DFREETYPE_INCLUDE_DIR_freetype2=${EXTERNALS2_DIRECTORY}/ft248/freetype-2.4.8/include 
		  -DFREETYPE_INCLUDE_DIR_ft2build=${EXTERNALS2_DIRECTORY}/ft248/freetype-2.4.8/include 
		  -DFREETYPE_LIBRARY:FILEPATH=${EXTERNALS2_DIRECTORY}/ft248/freetype-2.4.8/objs/win32/vc2010/freetype248MT.lib 
		  -DFB_PROJECTS_DIR:PATH=../GraphControl -DAGGSRC_DIR=../agg ../FireBreath" 

"@

$cmd = "cmake -G 'Visual Studio 10' -DCMAKE_BUILD_TYPE=RelWithDebInfo -DWITH_SYSTEM_BOOST=1 " `
              + "-DBOOST_INCLUDEDIR=${EXTERNALS2_DIRECTORY}/Boost/include/boost-1_46_1 " `
			  + "-DBOOST_LIBRARYDIR=${EXTERNALS2_DIRECTORY}/Boost/lib " `
			  + "-DGRAPHVIZSRC_DIR=${EXTERNALS2_DIRECTORY}/graphviz-2.26.3 " `
			  + "-DEXPAT_INCLUDE_DIR=${EXTERNALS2_DIRECTORY}/expat-2.0.1 " `
              + "-DEXPAT_LIBRARY=${EXTERNALS2_DIRECTORY}/expat-2.0.1 " `
			  + "-DFREETYPE_INCLUDE_DIR_freetype2=${EXTERNALS2_DIRECTORY}/ft248/freetype-2.4.8/include " `
			  + "-DFREETYPE_INCLUDE_DIR_ft2build=${EXTERNALS2_DIRECTORY}/ft248/freetype-2.4.8/include " `
			  + "-DFREETYPE_LIBRARY:FILEPATH=${EXTERNALS2_DIRECTORY}/ft248/freetype-2.4.8/objs/win32/vc2010/freetype248MT.lib " `
		      + "-DFB_PROJECTS_DIR:PATH=../GraphControl -DAGGSRC_DIR=../agg ../FireBreath" 

iex "$cmd; `$err=`$?"
if ( !($err) ) { exit 1 }

"Build HPCC"
build_hpcc
if ( ! ($?) ) { exit 1 }

"Copy package"
copy_package
if ( !($?) ) { exit 1 }

exit 0