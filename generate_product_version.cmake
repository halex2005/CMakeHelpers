include (CMakeParseArguments)
# NAME
# BUNDLE
# ICON               - path to application icon (${CMAKE_SOURCE_DIR}/product.ico by default)
# VERSION_MAJOR      - 1 is default
# VERSION_MINOR      - 0 is default
# VERSION_PATCH      - 0 is default
# VERSION_REVISION   - 0 is default
# COMPANY_NAME       - Eastwind is default
# COMPANY_COPYRIGHT  - Eastwind (C) Copyright 2015 is default
# COMMENTS
# ORIGINAL_FILENAME
# INTERNAL_NAME
# FILE_DESCRIPTION
function(generate_product_version outfiles)
    set (options)
    set (oneValueArgs NAME BUNDLE ICON VERSION_MAJOR VERSION_MINOR VERSION_PATCH VERSION_REVISION COMPANY_NAME COMPANY_COPYRIGHT COMMENTS ORIGINAL_FILENAME INTERNAL_NAME FILE_DESCRIPTION)
    set (multiValueArgs)
    cmake_parse_arguments(PRODUCT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT PRODUCT_ICON OR "${PRODUCT_ICON}" STREQUAL "")
        set(PRODUCT_ICON "${CMAKE_SOURCE_DIR}/product.ico")
    endif()

    if (NOT PRODUCT_VERSION_MAJOR OR "${PRODUCT_VERSION_MAJOR}" STREQUAL "")
        set(PRODUCT_VERSION_MAJOR 1)
    endif()
    if (NOT PRODUCT_VERSION_MINOR OR "${PRODUCT_VERSION_MINOR}" STREQUAL "")
        set(PRODUCT_VERSION_MINOR 0)
    endif()
    if (NOT PRODUCT_VERSION_PATCH OR "${PRODUCT_VERSION_PATCH}" STREQUAL "")
        set(PRODUCT_VERSION_PATCH 0)
    endif()
    if (NOT PRODUCT_VERSION_REVISION OR "${PRODUCT_VERSION_REVISION}" STREQUAL "")
        set(PRODUCT_VERSION_REVISION 0)
    endif()

    if (NOT PRODUCT_COMPANY_NAME OR "${PRODUCT_COMPANY_NAME}" STREQUAL "")
        set(PRODUCT_COMPANY_NAME "Eastwind")
    endif()
    if (NOT PRODUCT_COMPANY_COPYRIGHT OR "${PRODUCT_COMPANY_COPYRIGHT}" STREQUAL "")
        set(PRODUCT_COMPANY_COPYRIGHT "Eastwind (C) Copyright 2015")
    endif()
    if (NOT PRODUCT_FILE_DESCRIPTION OR "${PRODUCT_FILE_DESCRIPTION}" STREQUAL "")
        set(PRODUCT_FILE_DESCRIPTION "${PRODUCT_NAME}")
    endif()
    if (NOT PRODUCT_ORIGINAL_FILENAME OR "${PRODUCT_ORIGINAL_FILENAME}" STREQUAL "")
        set(PRODUCT_ORIGINAL_FILENAME "${PRODUCT_NAME}")
    endif()
    if (NOT PRODUCT_COMMENTS OR "${PRODUCT_COMMENTS}" STREQUAL "")
        set(PRODUCT_COMMENTS "${PRODUCT_NAME} v${PRODUCT_VERSION_MAJOR}.${PRODUCT_VERSION_MINOR}")
    endif()


    set (_VersionInfoFile ${CMAKE_CURRENT_BINARY_DIR}/VersionInfo.h)
    set (_VersionResourceFile ${CMAKE_CURRENT_BINARY_DIR}/VersionResource.rc)
    configure_file(
        ${CMAKE_SOURCE_DIR}/build/VersionInfo.in
        ${_VersionInfoFile}
        @ONLY)
    configure_file(
        ${CMAKE_SOURCE_DIR}/build/VersionResource.rc
        ${_VersionResourceFile}
        COPYONLY)
    list(APPEND ${outfiles} ${_VersionInfoFile} ${_VersionResourceFile})
    set (${outfiles} ${${outfiles}} PARENT_SCOPE)
endfunction()
