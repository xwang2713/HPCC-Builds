Function get_branch_tag
{
   $tb_name = $args[0]

   $commit = git tag | select-string $tb_name
   if ( ([string]::IsNullOrEmpty($commit)) )
   {
      $commit = git branch -a | select-string $tb_name
	  if ( ([string]::IsNullOrEmpty($commit)) )
	  {
         "Cannot find tag or branch name $tb_name.  commit: $commit"
	     exit 1
	  }
   }
   
   $revision = git rev-list $commit | select -First 1
   "Checkout $revision ($commit)"
   git checkout $revision
}

Function match_branch_suffix()
{
   "$($args[0])" -match "^\d+\.\d+\.\d+-(rc\d+|\d+)$"
}

Export-ModuleMember -Function get_branch_tag,match_branch_suffix