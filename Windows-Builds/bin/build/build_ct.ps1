$curDir = split-path $myInvocation.MyCommand.path
Import-Module ${curDir}/build_common.psm1 -Force

@"
  cmake -G \"Visual Studio 9 2008\" -DCMAKE_BUILD_TYPE=${cmake_build_type} -DUSE_NATIVE_LIBRARIES=OFF 
        -DCHECK_GIT_TAG=0 -DCLIENTTOOLS_ONLY=ON -DUSE_PYTHON=OFF -DUSE_V8=OFF -DUSE_JNI=OFF 
	    -DUSE_RINSIDE=OFF -DSIGN_DIRECTORY=${SIGN_DIRECTORY} 
		-DEXTERNALS_DIRECTORY=${EXTERNALS_DIRECTORY} -DUSE_APR=OFF -DUSE_MYSQL=OFF 
		-DUSE_SQLITE3=OFF -DUSE_XALAN=ON -DUSE_CASSANDRA=OFF  -DUSE_MEMCACHED=OFF ../HPCC-Platform
"@

$cmd = "cmake -G 'Visual Studio 9 2008' -DCMAKE_BUILD_TYPE=$cmake_build_type -DUSE_NATIVE_LIBRARIES=OFF " `
       + "-DCHECK_GIT_TAG=0 -DCLIENTTOOLS_ONLY=ON -DUSE_PYTHON=OFF -DUSE_V8=OFF -DUSE_JNI=OFF -DUSE_RINSIDE=OFF " `
       + "-DSIGN_DIRECTORY=${SIGN_DIRECTORY} -DEXTERNALS_DIRECTORY=${EXTERNALS_DIRECTORY} -DUSE_APR=OFF " `
	   + "-DUSE_MYSQL=OFF -DUSE_SQLITE3=OFF -DUSE_CASSANDRA=OFF  -DUSE_MEMCACHED=OFF -DUSE_XALAN=ON ../HPCC-Platform"
	   
iex "$cmd 2>&1 ; `$err=`$?"
#if ( !($err) ) { 
#    echo "cmake error: $err"
#    exit 1 
#}

"Build HPCC"
build_hpcc
if ( ! ($?) ) { exit 1 }

"Copy package"
copy_package
if ( !($?) ) { exit 1 }

exit 0
