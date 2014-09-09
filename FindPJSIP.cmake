#==============================================================
# Helper functions
#==============================================================
# Guesses CppRest's compiler prefix used in built library names
# Returns the guess by setting the variable pointed to by _ret
function(_PJSIP_GUESS_COMPILER_PREFIX _ret)
  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel"
      OR "${CMAKE_CXX_COMPILER}" MATCHES "icl"
      OR "${CMAKE_CXX_COMPILER}" MATCHES "icpc")
    if(WIN32)
      set (_PJSIP_COMPILER "-iw")
    else()
      set (_PJSIP_COMPILER "-il")
    endif()
  elseif (MSVC12)
    set(_PJSIP_COMPILER "120")
  elseif (MSVC11)
    set(_PJSIP_COMPILER "110")
  elseif (MSVC10)
    set(_PJSIP_COMPILER "100")
  elseif (MSVC90)
    set(_PJSIP_COMPILER "90")
  elseif (MSVC80)
    set(_PJSIP_COMPILER "80")
  elseif (MSVC71)
    set(_PJSIP_COMPILER "71")
  elseif (MSVC70) # Good luck!
    set(_PJSIP_COMPILER "7") # yes, this is correct
  elseif (MSVC60) # Good luck!
    set(_PJSIP_COMPILER "6") # yes, this is correct
  elseif (BORLAND)
    set(_PJSIP_COMPILER "-bcb")
  elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "SunPro")
    set(_PJSIP_COMPILER "-sw")
  elseif (MINGW)
    _PJSIP_COMPILER_DUMPVERSION(_PJSIP_COMPILER_VERSION)
    set(_PJSIP_COMPILER "-mgw${_PJSIP_COMPILER_VERSION}")
  elseif (UNIX)
    set(_PJSIP_COMPILER "")
  else()
    # TODO at least PJSIP_DEBUG here?
    set(_PJSIP_COMPILER "")
  endif()
  set(${_ret} ${_PJSIP_COMPILER} PARENT_SCOPE)
endfunction()

#-------------------------------------------------------------------------------
#
# Runs compiler with "-dumpversion" and parses major/minor
# version with a regex.
#
function(_PJSIP_COMPILER_DUMPVERSION _OUTPUT_VERSION)
  exec_program(${CMAKE_CXX_COMPILER}
    ARGS ${CMAKE_CXX_COMPILER_ARG1} -dumpversion
    OUTPUT_VARIABLE _PJSIP_COMPILER_VERSION
  )
  string(REGEX REPLACE "([0-9])\\.([0-9])(\\.[0-9])?" "\\1\\2"
    _PJSIP_COMPILER_VERSION ${_PJSIP_COMPILER_VERSION})
  set(${_OUTPUT_VERSION} ${_PJSIP_COMPILER_VERSION} PARENT_SCOPE)
endfunction()


#-------------------------------------------------------------------------------
#
# Setup environment
#
if(WIN32)
    set (PJSIP_ROOT_DIR "d:/Development/git/pjsip/dependencies/pjproject-2.2.1")
    set (PJSIP_INCLUDE_DIR ${PJSIP_ROOT_DIR})
    set (PJSIP_LIBRARY_DIR ${PJSIP_ROOT_DIR}/lib)
    set (PJSIP_LIBRARY_DIRS ${PJSIP_LIBRARY_DIR})

    _PJSIP_GUESS_COMPILER_PREFIX(PJSIP_COMPILER)

    find_path(PJSIP_PJLIB_INCLUDE_DIR pjlib.h "${PJLIB_ROOT_DIR}/pjlib/include")
    find_path(PJSIP_PJLIB_UTIL_INCLUDE_DIR pjlib-util.h "${PJLIB_ROOT_DIR}/pjlib-util/include")
    find_path(PJSIP_PJMEDIA_INCLUDE_DIR pjmedia.h "${PJLIB_ROOT_DIR}/pjmedia/include")
    find_path(PJSIP_PJNATH_INCLUDE_DIR pjnath.h "${PJLIB_ROOT_DIR}/pjnath/include")
    find_path(PJSIP_PJSIP_INCLUDE_DIR pjsip.h "${PJLIB_ROOT_DIR}/pjsip/include")

    set (PJSIP_INCLUDE_DIR
        ${PJSIP_PJLIB_INCLUDE_DIR}
        ${PJSIP_PJLIB_UTIL_INCLUDE_DIR}
        ${PJSIP_PJMEDIA_INCLUDE_DIR}
        ${PJSIP_PJNATH_INCLUDE_DIR}
        ${PJSIP_PJSIP_INCLUDE_DIR}
    )
    set (PJSIP_INCLUDE_DIRS ${PJSIP_INCLUDE_DIR})

    if( CMAKE_SIZEOF_VOID_P EQUAL 8 )
        set(PJSIP_Platform_Suffix "x86_64-x64-vc${PJSIP_COMPILER}")
    else()
        set(PJSIP_Platform_Suffix "i386-Win32-vc${PJSIP_COMPILER}")
    endif()

    set(PJSIP_Platform_Suffix "${PJSIP_Platform_Suffix}-${CMAKE_CFG_INTDIR}")

    if (PJSIP_USE_STATIC_RUNTIME)
        set(PJSIP_Platform_Suffix "${PJSIP_Platform_Suffix}-Static")
    else()
        set(PJSIP_Platform_Suffix "${PJSIP_Platform_Suffix}-Dynamic")
    endif()

    set (PJSIP_LIBRARIES libpjproject-${PJSIP_Platform_Suffix})
    if ("${PJSIP_INCLUDE_DIRS}" MATCHES "NOTFOUND" OR "${PJSIP_LIBRARY_DIRS}" MATCHES "NOTFOUND")
        set(PJSIP_FOUND 0)
    else()
        set (PJSIP_FOUND 1)
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
endif()