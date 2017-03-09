$curDir = split-path $myInvocation.MyCommand.path
Import-Module ${curDir}/build_common.psm1 -Force

cp -r ${SIGN_DIRECTORY} -destination ../../



@"
   cmake  -G "Visual Studio 14 Win64" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DWITH_SYSTEM_BOOST=1 
          -DBOOST_INCLUDEDIR=${EXTERNALS2_DIRECTORY}/boost/1.60.0 `
		  -DBOOST_LIBRARYDIR=${EXTERNALS2_DIRECTORY}/boost/1.60.0/lib64-msvc-14.0 `
		  -DGRAPHVIZSRC_DIR=${EXTERNALS2_DIRECTORY}/graphviz/2.26.3  `
		  -DEXPAT_INCLUDE_DIR=${EXTERNALS2_DIRECTORY}/expat/2.0.1 `
		  -DEXPAT_LIBRARY=${EXTERNALS2_DIRECTORY}/expat-2.0.1   `
		  -DFREETYPE_INCLUDE_DIR_freetype2=${EXTERNALS2_DIRECTORY}/freetype2/2.4.8/include  `
		  -DFREETYPE_INCLUDE_DIR_ft2build=${EXTERNALS2_DIRECTORY}/ft248/freetype-2.4.8/include `
		  -DFREETYPE_LIBRARY:FILEPATH=${EXTERNALS2_DIRECTORY}/freetype2/2.4.8/objs/win64/vc2015/freetype248MT.lib `
		  -DFB_PROJECTS_DIR:PATH=../GraphControl -DAGGSRC_DIR:PATH=../../agg ../../FireBreath 

"@

$cmd = "cmake -G 'Visual Studio 14 Win64' -DCMAKE_BUILD_TYPE=RelWithDebInfo -DWITH_SYSTEM_BOOST=1 " `
              + "-DBOOST_INCLUDEDIR=${EXTERNALS2_DIRECTORY}/boost/1.60.0 " `
			  + "-DBOOST_LIBRARYDIR=${EXTERNALS2_DIRECTORY}/boost/1.60.0/lib64-msvc-14.0 " `
			  + "-DGRAPHVIZSRC_DIR=${EXTERNALS2_DIRECTORY}/graphviz/2.26.3 " `
			  + "-DEXPAT_INCLUDE_DIR=${EXTERNALS2_DIRECTORY}/expat/2.0.1 " `
              + "-DEXPAT_LIBRARY=${EXTERNALS2_DIRECTORY}/expat/2.0.1 " `
			  + "-DFREETYPE_INCLUDE_DIR_freetype2=${EXTERNALS2_DIRECTORY}/freetype2/2.4.8/include " `
			  + "-DFREETYPE_INCLUDE_DIR_ft2build=${EXTERNALS2_DIRECTORY}/freetype2/2.4.8/include " `
			  + "-DFREETYPE_LIBRARY:FILEPATH=${EXTERNALS2_DIRECTORY}/freetype2/2.4.8/objs/win64/vc2015/freetype248MT.lib " `
		      + "-DAGGSRC_DIR:PATH=../../agg -DFB_PROJECTS_DIR:PATH=../GraphControl ../../FireBreath" 

iex "$cmd 2>&1; `$err=`$?"
#if ( !($err) ) { exit 1 }

"Build HPCC"
build_hpcc sign2
if ( ! ($?) ) { exit 1 }

"Copy package"
copy_package
if ( !($?) ) { exit 1 }

exit 0