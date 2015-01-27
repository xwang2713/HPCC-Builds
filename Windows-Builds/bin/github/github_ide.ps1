$github_directory = split-path $myInvocation.MyCommand.path
Import-Module  ${github_directory}/github_common.psm1 -Force

if ( ([string]::IsNullOrEmpty($args[0])) )
{
   "Miss tag or branch name"
   exit 1
}

$TAG_BRANCH_NAME = $args[0]
#-----------------------------------------------------------
# Get ECLIDE Repository
#-----------------------------------------------------------
""
"Get ECLIDE repo"
$IDE_DIR = "ECLIDE"
$IDE_REPO    = "https://github.com/${GITHUB_USER}/ECLIDE.git"

if ( Test-Path $IDE_DIR ) { rm -r -Force $IDE_DIR }
mkdir $IDE_DIR | Out-Null
git clone $IDE_REPO

cd $IDE_DIR
get_branch_tag $TAG_BRANCH_NAME
cd ..


#-----------------------------------------------------------
# Get GrahpControl Repository
#-----------------------------------------------------------
""
"Get GraphControl repo"
$GC_DIR = "GraphControl"
$GC_REPO    = "https://github.com/${GITHUB_USER}/GraphControl.git"

if ( Test-Path $GC_DIR ) { rm -r -Force $GC_DIR }
mkdir $GC_DIR | Out-Null
git clone $GC_REPO

cd $GC_DIR
get_branch_tag $TAG_BRANCH_NAME
cd ..



exit 0
