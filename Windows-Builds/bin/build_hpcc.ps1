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
	  6. SALT Lite
	  7. SALT
Usage:  ./build_hpcc.ps1 -branch <branch or tag>  -project <project id separated by common> or all>
            -external <externals directory, default: Z:/build/windows/externals> 
			-external2 <externals2 directory, default: Z:/build/windows/externals2> 
			-sign <sign directory, default: Z:/build/windows/sign> 
			-docs <ECL IDE docs root directory, default: Z:/build/windows/ECLIDE/docs> -release <relation name (optional)>
			-ct_version client tools version for building ECLIDE
			-gc_version graphic control version for building ECLIDE
			-github_user github user. Default is hpcc-systems
			Under docs the directory struction is ECLIDE/docs/<release>/.
			If projects is set to 'all' it will build 1,2,3,4 since KEL and SALT branches are 
			different from HPCC core components.
			
.EXAMPLE
./build_hpcc.ps1 -branch 5.0.0-1 -project 1,2,3,4 -release 5.0.0

.EXAMPLE
./build_hpcc.ps1 -branch 5.0.0-1 -p 4
This will build ECLIDE with release varialbe set to 5.0.0-1. 
ECLIDE requires Clienttools and GraphControls 32bit. These two should be built first.

.NOTES
<-release> will be build top level directory under workspace directory. Build resuls will be 
under output directory.

.LINK
https://github.com/xwang2713/HPCC-Builds.git

#>

param(
       $branch=$(
	      Throw "Missing branch/tag suffix or full name. For example 6.2.6-1"),
       $projects="all",
	   $release="",
	   $externals="Z:/build/windows/platform_externals_vs2015",
	   $externals2="Z:/build/windows/gc_eclide_externals_vs2015",
	   $sign="C:/HPCC/sign",
	   $docs="Z:/build/windows/ECLIDE/docs",
	   $ct_build="",
	   $gc_build="",
	   $github_user="hpcc-systems",
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
if ( $projects -eq 'all' )
{
   $projects = '1 2 3 4'
}
if ( $ct_build -eq "" )
{
    $ct_build = $release
}
if ( $gc_build -eq "" )
{
    $gc_build = $release
}

$global:EXTERNALS_DIRECTORY  =  $externals
$global:EXTERNALS2_DIRECTORY =  $externals2
$global:SIGN_DIRECTORY       =  $sign
$global:DOCS_DIRECTORY       =  $docs
$global:GITHUB_USER          =  $github_user

	  
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
                       "graphcontrol_32bits.psm1",
					   "graphcontrol_64bits.psm1",
					   "eclide.psm1",
					   "kel.psm1",
					   "salt_lite.psm1",
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
    mkdir ${root_directory}/workspace/${release}/output | Out-Null
}
cd ${root_directory}/workspace
$global:work_directory = $pwd.Path

cd ${work_directory}/${release}
$global:release_directory = $pwd.Path
$global:output_directory = "${release_directory}/output"
$global:ct_directory = "${work_directory}/${ct_build}/clienttools"
$global:gc_directory = "${work_directory}/${gc_build}/graphcontrol_32bits"

$projects = $projects -replace ',', ' '
$supported_projects = Get-Content ${bin_directory}/config/os/win.conf | %{$_.split('=')[1]}

#-----------------------------------------------------------
# Iterate each selected project and build
#-----------------------------------------------------------	
foreach ($project_id in $projects)
{
    cd $release_directory
    if ( ! (" $supported_projects ").contains(" $project_id " ) )
	{
	    "Unknown project id $project_id"
		continue
	}
	#del variable:\global:github_script
	$config_file = $project_config_file[$project_id]
	
	#Remove-Module  ${bin_directory}/config/$config_file
	Import-Module  ${bin_directory}/config/$config_file -Force
	""
	"Build $display_name ..."
	if ( ! (Test-Path $project_directory ) )
    {
       mkdir $project_directory | Out-Null
    }
    
	cd $project_directory
	
	Write-Host -NoNewline "Get git repository $branch ... "
	& ${bin_directory}\github\${github_script} $branch > git.log 2>&1
    if ( !($?) ) 
    {
       "FAILED"
       continue
    }
    "OK"

	cd ${release_directory}/${project_directory}
	if ( ! ([string]::IsNullOrEmpty($build_directory)) )
	{
	    if ( (Test-Path $build_directory ) )
        {
           rm -r -Force $build_directory
        }
	    mkdir $build_directory | Out-Null
	    cd $build_directory
	}
	
	Write-Host -NoNewline "Build ... "
	& ${bin_directory}/build/${build_script} > build.log 2>&1
    if ( !($?) ) 
    {
       "FAILED"
       continue
    }
    "OK"
}

cd ${bin_directory}