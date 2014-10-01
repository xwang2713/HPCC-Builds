$global:display_name        = "HPCCSystem GraphControl Community 64bits"
$global:project_directory   = "graphcontrol_64bits"
$global:github_script       = "github_gc.ps1"
$global:build_directory        = "build/GraphControl"
$global:build_script        = "build_gc64.ps1"
$global:package_name_prefix = "hpccsystems-graphcontrol_community"
$global:package_directory   = "bin/graphcontrol"
$global:cmake_build_type = "RelWithDebInfo"

Export-ModuleMember -Variable display_name,project_directory,github_script,
       build_directory,build_script,package_name_prefix,package_directory