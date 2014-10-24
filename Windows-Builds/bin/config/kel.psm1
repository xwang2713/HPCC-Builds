$global:display_name        = "HPCCSystems KEL"
$global:project_directory   = "KEL"
$global:github_script       = "github_kel.ps1"
$global:build_directory        = "build"
$global:build_script        = "build_kel.ps1"
$global:package_name_prefix = "hpccsystems-kel"
$global:package_directory   = "bin/kel"
$global:cmake_build_type = "Release"

Export-ModuleMember -Variable display_name,project_directory,github_script,
       build_directory,build_script,package_name_prefix,package_directory