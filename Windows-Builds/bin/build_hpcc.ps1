#-----------------------------------------------------------
# build_hpcc.ps1
#-----------------------------------------------------------
<#

.SYNOPSIS
Build supported HPCC Components on Windows

.DESCRIPTION
This is top Poswershell script to build HPCC Components on Windows
Current supported HPCC Components on Windows:
      1. Clienttools
	  2. GraphControl 32bit
	  3. GraphControl 64bit
	  4. ECLIDE
	  5. KEL
	  6. SALT
Usage:  ./build_hpcc.sh -branch <branch or tag>  -project <project id separated by common> or all>
               -release <relation name (optional)>
.EXAMPLE
./build_hpcc.sh -branch 5.0.0-1 -project 1,2,3,4 -release 5.0.0

.EXAMPLE
./build_hpcc.sh -branch 5.0.0-1 -p 4
This will build ECLIDE with release varialbe set to 5.0.0-1. 
ECLIDE requires Clienttools and GraphControls 32bit. These two should be built first.

.NOTES
<-release> will be build top level directory under workspace directory. Build resuls will be 
under output directory.

.LINK
https://github.com/xwang2713/HPCC-Builds.git

#>
#-----------------------------------------------------------
# Input parameters
#-----------------------------------------------------------
param(
       $branch=$(
	      Throw "Missing branch/tag suffix or full name. For example 5.0.0-1"),
       $projects="all",
	   $release="",
	   [bool]$reset
	  )

#$myInvocation.MyCommand.Name
$bin_directory  = split-path $myInvocation.MyCommand.path
$root_directory = split-path $bin_directory

#Import-Module  ${bin_directory}\common.psm1
	  
if ( $release -eq "" )
{
    $release = $branch
}
	  
@" 

           Build HPCC Components on Windows
           --------------------------------
           Branch/tag       : $branch
           Project          : $projects
           Release          : $release
		   
"@
#-----------------------------------------------------------
# Project configuration files
#-----------------------------------------------------------
$project_config_file = "Project configuration",
                       "clienttools.psm1",
                       "graphcontrol_32bit.psm1",
					   "graphcontrol_64bit.psm1",
					   "eclide.psm1",
					   "kel.psm1",
					   "salt.psm1"

#-----------------------------------------------------------
# System information
#-----------------------------------------------------------	
$global:DISTRO     = (Get-WMIObject Win32_OperatingSystem).caption
$global:OS_VERSION = (Get-WMIObject Win32_OperatingSystem).version
$global:ARCH       = (Get-WMIObject Win32_OperatingSystem).osarchitecture
$global:PKG_TYPE   = "exe"
@"		

$DISTRO
Version: $OS_VERSION, architecture: $ARCH
   
"@
#-----------------------------------------------------------
# Prepare working directories
#-----------------------------------------------------------					   
if ( ! (Test-Path ${root_directory}/workspace/${release}/output) ) 
{
    mkdir -p ${root_directory}/workspace/${release}/output | Out-Null
}
cd ${root_directory}/workspace
$global:work_directory = $pwd.Path

cd ${work_directory}/${release}
$global:release_directory = $pwd.Path
$global:output_directory = "${release_directory}/output"
${project_config_file}[1]
foreach ($project_id in $projects)
{
    #echo  ${bin_directory}/${project_config_file}[1]
	"$project_config_file[$project_id]"
	#Import-Module  ${bin_directory}/${project_config_file[$project]}
}

cd ${bin_directory}