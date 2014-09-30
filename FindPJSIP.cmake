#-------------------------------------------------------------------------------
#
# Setup environment
#
#-------------------------------------------------------------------------------
# If PJSIP_DIR is not set, look for PJSIPROOT and PJSIP_ROOT
# as alternatives, since these are more conventional for PJSIP.
if ("$ENV{PJSIP_DIR}" STREQUAL "")
    if (NOT "$ENV{PJSIP_ROOT}" STREQUAL "")
        set(ENV{PJSIP_DIR} $ENV{PJSIP_ROOT})
    elseif (NOT "$ENV{PJSIPROOT}" STREQUAL "")
        set(ENV{PJSIP_DIR} $ENV{PJSIPROOT})
    endif()
endif()
mark_as_advanced(PJSIP_DIR)
set(PJSIP_ROOT_DIR $ENV{PJSIP_DIR})

if(WIN32)
    set(PJSIP_VERSION 2.3.0)
    if (PJSIP_USE_STATIC_RUNTIME)
        set(PJSIP_CRT_LINKAGE Static)
    else()
        set(PJSIP_CRT_LINKAGE Dynamic)
    endif()

    find_package(PkgConfig)
    if (PkgConfig_FOUND)
        if (NOT ${PKG_CONFIG_PATH} STREQUAL "" AND IS_DIRECTORY ${PKG_CONFIG_PATH})
            # environment variable PKG_CONFIG_PATH exists and it is directory
            if (NOT EXISTS ${PKG_CONFIG_PATH}/libpjproject.pc)
                configure_file(${CMAKE_CURRENT_LIST_DIR}/libpjproject.in ${PKG}/libpjproject.pc)
            endif()
        else()
            # there is no PKG_CONFIG_PATH environment variable
        endif()
        if (PJSIP_FIND_VERSION)
            if (PJSIP_FIND_VERSION_EXACT)
                pkg_check_modules(PJSIP libpjproject=${PJSIP_FIND_VERSION} REQUIRED)
            else()
                pkg_check_modules(PJSIP libpjproject>=${PJSIP_FIND_VERSION} REQUIRED)
            endif()
        else()
            pkg_check_modules(PJSIP libpjproject REQUIRED)
        endif()
    else()
        if( CMAKE_SIZEOF_VOID_P EQUAL 8 )
            set(PJSIP_TargetCPU "x86_64")
        else()
            set(PJSIP_TargetCPU "i386")
        endif()

        find_path(PJSIP_PJLIB_INCLUDE_DIR      NAMES "pjlib.h"      PATHS "${PJSIP_ROOT_DIR}/pjlib/include")
        find_path(PJSIP_PJLIB_UTIL_INCLUDE_DIR NAMES "pjlib-util.h" PATHS "${PJSIP_ROOT_DIR}/pjlib-util/include")
        find_path(PJSIP_PJMEDIA_INCLUDE_DIR    NAMES "pjmedia.h"    PATHS "${PJSIP_ROOT_DIR}/pjmedia/include")
        find_path(PJSIP_PJNATH_INCLUDE_DIR     NAMES "pjnath.h"     PATHS "${PJSIP_ROOT_DIR}/pjnath/include")
        find_path(PJSIP_PJSIP_INCLUDE_DIR      NAMES "pjsip.h"      PATHS "${PJSIP_ROOT_DIR}/pjsip/include")

        set (PJSIP_INCLUDE_DIR
            ${PJSIP_PJLIB_INCLUDE_DIR}
            ${PJSIP_PJLIB_UTIL_INCLUDE_DIR}
            ${PJSIP_PJMEDIA_INCLUDE_DIR}
            ${PJSIP_PJNATH_INCLUDE_DIR}
            ${PJSIP_PJSIP_INCLUDE_DIR}
        )

        set (PJSIP_LIBRARY_DIR ${PJSIP_ROOT_DIR}/lib)
        if (PJSIP_USE_STATIC_RUNTIME)
            set (PJSIP_LIBRARIES libpjproject-$(Platform)-$(PlatformToolset)-$(Configuration)-Static.lib)
        else
            set (PJSIP_LIBRARIES libpjproject-$(Platform)-$(PlatformToolset)-$(Configuration)-Dynamic.lib)
        endif()

        set (PJSIP_INCLUDE_DIRS ${PJSIP_INCLUDE_DIR})
        set (PJSIP_LIBRARY_DIRS ${PJSIP_LIBRARY_DIR})

        if ("${PJSIP_INCLUDE_DIRS}" MATCHES "NOTFOUND" OR "${PJSIP_LIBRARY_DIRS}" MATCHES "NOTFOUND")
            set(PJSIP_FOUND 0)
        else()
            set (PJSIP_FOUND 1)
        endif()
    endif()
elseif(UNIX)
    find_package(PkgConfig REQUIRED)
    if (PJSIP_FIND_VERSION)
        if (PJSIP_FIND_VERSION_EXACT)
            pkg_check_modules(PJSIP libpjproject=${PJSIP_FIND_VERSION} REQUIRED)
        else()
            pkg_check_modules(PJSIP libpjproject>=${PJSIP_FIND_VERSION} REQUIRED)
        endif()
    else()
        pkg_check_modules(PJSIP libpjproject REQUIRED)
    endif()
endif()

if (PJSIP_DEBUG)
    message(STATUS "PJSIP_ROOT_DIR     = ${PJSIP_ROOT_DIR}")
    message(STATUS "PJSIP_FOUND        = ${PJSIP_FOUND}")
    message(STATUS "PJSIP_INCLUDE_DIRS = ${PJSIP_INCLUDE_DIRS}")
    message(STATUS "PJSIP_LIBRARY_DIRS = ${PJSIP_LIBRARY_DIRS}")
    message(STATUS "PJSIP_LIBRARIES    = ${PJSIP_LIBRARIES}")
    message(STATUS "PJSIP_VERSION      = ${PJSIP_VERSION}")
endif()