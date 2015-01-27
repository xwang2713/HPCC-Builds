$global:display_name        = "HPCCSystems ECLIDE"
$global:project_directory   = "eclide"
$global:github_script       = "github_ide.ps1"
$global:build_directory        = "build"
$global:build_script        = "build_ide.ps1"
$global:package_name_prefix = "hpccsystems-eclide-community"
$global:package_directory   = "bin/eclide"
$global:cmake_build_type = "RelWithDebInfo"

Export-ModuleMember -Variable display_name,project_directory,github_script,
       build_directory,build_script,package_name_prefix,package_directory
