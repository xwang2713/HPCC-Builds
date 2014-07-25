
#$DISTRO     = (Get-WMIObject Win32_OperatingSystem).caption
   $OS_VERSION = (Get-WMIObject Win32_OperatingSystem).version
   $ARCH       = (Get-WMIObject Win32_OperatingSystem).osarchitecture
   $PKG_TYPE   = "exe"
   
$script:DISTRO="xxxxx"
#Export-MoudleMember $DISTRO