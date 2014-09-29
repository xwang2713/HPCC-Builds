$github_directory = split-path $myInvocation.MyCommand.path

if ( ([string]::IsNullOrEmpty($args[0])) )
{
   "Miss tag or branch name"
   exit 1
}

& ${github_directory}/github_ce.ps1 $args[0] OFF
if ( ! ($?) ) { exit 1 }
exit 0