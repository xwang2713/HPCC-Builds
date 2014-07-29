$global:display_name        = "HPCCSystem Clienttools Community"
$global:project_directory   = "clienttools"
$global:github_script       = "github_ce.ps1"
$global:build_script        = "build_ct.ps1"
$global:package_name_prefix = "hpccsystems-clienttools_community"
$global:package_directory   = "bin/clienttools"

Export-ModuleMember -Variable display_name,project_directory,github_script,
       build_script,package_name_prefix,package_directory