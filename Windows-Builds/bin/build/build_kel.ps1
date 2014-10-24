$curDir = split-path $myInvocation.MyCommand.path
Import-Module ${curDir}/build_common.psm1 -Force
cd ../${project_directory} 
$cmd = "ant dist -Dhpcc-version=${release} -Dsign_directory=${SIGN_DIRECTORY}"    
"$cmd"	   
ant dist -Dhpcc-version="`"${release}`"" -Dsign_directory="${SIGN_DIRECTORY}"
#iex "$cmd 2>&1 ; `$err=`$?"
#if ( !($err) ) { 
#    echo "cmake error: $err"
#    exit 1 
#}

"Copy package"
cd output
copy_package
if ( !($?) ) { exit 1 }

exit 0