$github_directory = split-path $myInvocation.MyCommand.path
Import-Module  ${github_directory}/github_common.psm1 -Force

if ( ([string]::IsNullOrEmpty($args[0])) )
{
   "Miss tag or branch name"
   exit 1
}

$TAG_BRANCH_NAME = $args[0]

#-----------------------------------------------------------
# Get KEL Repository
#-----------------------------------------------------------
""
"Get KEL repo"
$KEL_DIR = "KEL"
$KEL_REPO    = "https://github.com/${GITHUB_USER}/KEL.git"

if ( Test-Path $KEL_DIR ) { rm -r -Force $KEL_DIR }
mkdir $KEL_DIR | Out-Null
git clone $KEL_REPO

cd $KEL_DIR
get_branch_tag $TAG_BRANCH_NAME
cd ..

exit 0
