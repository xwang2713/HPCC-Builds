Function build_hpcc
{
   iex "cmake --build . --config $cmake_build_type 2>&1; `$err=`$?"
   if ( ! ($err) ) { throw "Fails to compile" }
   
   iex "cmake --build . --config $cmake_build_type  --target package 2>&1; `$err=`$?"
   if ( ! ($err) ) { throw "Fails to package" }
	
   iex "cmake --build . --config $cmake_build_type  --target sign 2>&1; `$err=`$?"
   if ( ! ($err) ) { throw "Fails to sign" }
   
}

Function copy_package
{
   if ( ! (Test-Path ${output_directory}/${package_directory} ) )
   {
       mkdir ${output_directory}/${package_directory} | Out-Null
   }
   "Copy ${package_name_prefix}*${PKG_TYPE} ${output_directory}/${package_directory}/"
   cp ${package_name_prefix}*${PKG_TYPE} -destination ${output_directory}/${package_directory}/
   
   if ( ! (Test-Path ${output_directory}/${package_directory}/${package_name_prefix}*${PKG_TYPE} ) )
   {
       throw "Fails to copy ${package_name_prefix}*${PKG_TYPE}"
	   
   }
}

Export-ModuleMember -Function build_hpcc,copy_package