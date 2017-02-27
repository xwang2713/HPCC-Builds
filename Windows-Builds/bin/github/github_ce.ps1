$github_directory = split-path $myInvocation.MyCommand.path
Import-Module  ${github_directory}/github_common.psm1 -Force



if ( ([string]::IsNullOrEmpty($args[0])) )
{
   "Miss tag or branch name"
   exit 1
}

$TAG_BRANCH_NAME = $args[0]

$SUBMODULE = $TRUE
"Get submodule 1: $SUBMODULE"
if ( [string]::IsNullOrEmpty($args[1])  ) 
{
    $SUBMODULE = $FALSE
}

$PLATFORM_DIR = "HPCC-Platform"
$HPCC_REPO    = "https://github.com/${GITHUB_USER}/HPCC-Platform.git"

""
"Get HPCC Platform repo"
if ( Test-Path $PLATFORM_DIR ) { rm -r -Force $PLATFORM_DIR }
mkdir $PLATFORM_DIR | Out-Null
git clone $HPCC_REPO

cd $PLATFORM_DIR

get_branch_tag $TAG_BRANCH_NAME

if ( ! $SUBMODULE ) { exit }

""
"Git submodule update --init"
git submodule update --init

exit 0
