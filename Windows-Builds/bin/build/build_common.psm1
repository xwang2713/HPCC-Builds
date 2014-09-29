Function build_hpcc
{
   iex "cmake --build . --config $cmake_build_type; `$err=`$?"
   if ( ! ($err) ) { PSCmdlet.Write-error ("Fails to compile") }
   
   iex "cmake --build . --config $cmake_build_type  --target package"
    if ( ! ($err) ) { PSCmdlet.Write-error ("Fails to package") }
	
   iex "cmake --build . --config $cmake_build_type  --target sign"
    if ( ! ($err) ) { PSCmdlet.Write-error ("Fails to sign") }
   
}

Function copy_package
{
   if ( ! (Test-Path ${output_directory}/${package_directory} ) )
   {
       mkdir ${output_directory}/${package_directory} | Out-Null
   }
   "Copy ${package_name_prefix}*${PKG_TYPE} ${output_directory}/${package_directory}/"
   cp ${package_name_prefix}*${PKG_TYPE} -destination ${output_directory}/${package_directory}/
}

Export-ModuleMember -Function build_hpcc,copy_package