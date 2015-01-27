$global:display_name        = "HPCCSystem Clienttools Community"
$global:project_directory   = "clienttools"
$global:github_script       = "github_ct.ps1"
$global:build_directory        = "build"
$global:build_script        = "build_ct.ps1"
$global:package_name_prefix = "hpccsystems-clienttools-community"
$global:package_directory   = "bin/clienttools"
$global:cmake_build_type = "Release"

Export-ModuleMember -Variable display_name,project_directory,github_script,
       build_directory,build_script,package_name_prefix,package_directory
