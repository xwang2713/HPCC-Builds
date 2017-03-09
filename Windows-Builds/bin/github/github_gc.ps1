$github_directory = split-path $myInvocation.MyCommand.path
Import-Module  ${github_directory}/github_common.psm1 -Force

if ( ([string]::IsNullOrEmpty($args[0])) )
{
   "Miss tag or branch name"
   exit 1
}

$TAG_BRANCH_NAME = $args[0]

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

#-----------------------------------------------------------
# Get FireBreath Repository
#-----------------------------------------------------------
""
"Get FireBreath repo"
$FB_DIR = "FireBreath"
$FB_REPO    = "https://github.com/GordonSmith/FireBreath.git"

if ( Test-Path $FB_DIR ) { rm -r -Force $FB_DIR }
mkdir $FB_DIR | Out-Null
git clone $FB_REPO

cd $FB_DIR
get_branch_tag candidate-6.0.0
cd ..
#-----------------------------------------------------------
# Get AGG Repository
#-----------------------------------------------------------
""
"Get AGG repo"
$AGG_DIR = "agg"
$AGG_REPO    = "https://github.com/GordonSmith/agg.git"

if ( Test-Path $AGG_DIR ) { rm -r -Force $AGG_DIR }
mkdir $AGG_DIR | Out-Null
git clone $AGG_REPO

cd $AGG_DIR
get_branch_tag candidate-6.0.0
cd ..

exit 0
