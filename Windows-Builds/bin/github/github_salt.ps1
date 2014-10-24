$github_directory = split-path $myInvocation.MyCommand.path
Import-Module  ${github_directory}/github_common.psm1 -Force

if ( ([string]::IsNullOrEmpty($args[0])) )
{
   "Miss tag or branch name"
   exit 1
}

$TAG_BRANCH_NAME = $args[0]

#-----------------------------------------------------------
# Get SALT Repository
#-----------------------------------------------------------
""
"Get SALT repo"
$SALT_DIR = "KEL"
$SALT_REPO    = "https://github.com/hpcc-systems/SALT.git"

if ( Test-Path $SALT_DIR ) { rm -r -Force $SALT_DIR }
mkdir $SALT_DIR | Out-Null
git clone $SALT_REPO

cd $SALT_DIR
get_branch_tag $TAG_BRANCH_NAME
cd ..

exit 0