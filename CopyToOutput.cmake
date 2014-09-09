#########################################################
# Copy local file to output directory of specified target
# Usage:
#   include(CopyToOutput)
#   copy_local_to_output(target-name settings.xml)
macro (copy_local_to_output target_name local_file_name)
    add_custom_command(
        TARGET ${target_name} PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${local_file_name} $<TARGET_FILE_DIR:${target_name}>)
endmacro()

#########################################################
# Copy file to output directory of specified target
# Usage:
#   include(CopyToOutput)
#   copy_to_output(target-name ${FullPathToFile}/settings.xml)
macro (copy_to_output target_name file_name)
    add_custom_command(
        TARGET ${target_name} PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy ${file_name} $<TARGET_FILE_DIR:${target_name}>)
endmacro()
