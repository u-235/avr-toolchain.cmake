#
# License: MIT
# Copyright (c) 2021 Nick Egorrov
#
#[=============================================================================[

The following variables are changed in this module:

- CMAKE_SYSTEM_NAME      = Generic
- CMAKE_SYSTEM_PROCESSOR = AVR

- AVR_TOOLCHAIN_ID       = GNU
- AVR_TOOLCHAIN_VERSION
- AVR_TOOLCHAIN_ROOT_DIR in Linux usually /usr or /usr/local
- AVR_TOOLCHAIN_AVR_DIR  = ${AVR_TOOLCHAIN_ROOT_DIR}/lib/gcc/avr/${AVR_TOOLCHAIN_VERSION}

- AVR_TOOLCHAIN_C_COMPILER
- AVR_TOOLCHAIN_CXX_COMPILER

- CMAKE_C_COMPILER
- CMAKE_C_COMPILER_VERSION
- CMAKE_C_FLAGS                cleared
- CMAKE_C_FLAGS_DEBUG          cleared
- CMAKE_C_FLAGS_RELEASE        cleared
- CMAKE_C_FLAGS_MINSIZEREL     cleared
- CMAKE_C_FLAGS_RELWITHDEBINFO cleared

- CMAKE_CXX_COMPILER
- CMAKE_CXX_COMPILER_VERSION
- CMAKE_CXX_FLAGS                cleared
- CMAKE_CXX_FLAGS_DEBUG          cleared
- CMAKE_CXX_FLAGS_RELEASE        cleared
- CMAKE_CXX_FLAGS_MINSIZEREL     cleared
- CMAKE_CXX_FLAGS_RELWITHDEBINFO cleared

- CMAKE_FIND_LIBRARY_PREFIXES
- CMAKE_FIND_LIBRARY_SUFFIXES

#]=============================================================================]


list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/modules)

set(AVR_TOOLCHAIN_ID      GNU)
set(AVR_TOOLCHAIN_VERSION 0.3)

set(CMAKE_SYSTEM_NAME      Generic)
set(CMAKE_SYSTEM_PROCESSOR AVR)

find_program(AVR_TOOLCHAIN_C_COMPILER   avr-gcc REQUIRED)
find_program(AVR_TOOLCHAIN_CXX_COMPILER avr-g++ REQUIRED)
set(CMAKE_C_COMPILER      ${AVR_TOOLCHAIN_C_COMPILER})
set(CMAKE_CXX_COMPILER    ${AVR_TOOLCHAIN_CXX_COMPILER})

# Get GCC version.
execute_process(COMMAND ${CMAKE_C_COMPILER} --version OUTPUT_VARIABLE _VERSION ERROR_VARIABLE _VERSION)

if("${_VERSION}" MATCHES "\\(GCC\\) ([0-9]+\\.[0-9]+\\.[0-9]+)")
    set(_VERSION ${CMAKE_MATCH_1})
    set(CMAKE_C_COMPILER_VERSION ${_VERSION})
    set(CMAKE_CXX_COMPILER_VERSION ${_VERSION})
    set(CMAKE_ASM_COMPILER_VERSION ${_VERSION})
endif()

# Set AVR_TOOLCHAIN_ROOT_DIR and AVR_TOOLCHAIN_AVR_DIR
get_filename_component(AVR_TOOLCHAIN_ROOT_DIR "${AVR_TOOLCHAIN_C_COMPILER}" DIRECTORY)
get_filename_component(AVR_TOOLCHAIN_ROOT_DIR "${AVR_TOOLCHAIN_ROOT_DIR}/../" ABSOLUTE)
get_filename_component(AVR_TOOLCHAIN_AVR_DIR "${AVR_TOOLCHAIN_ROOT_DIR}/lib/gcc/avr/${_VERSION}" ABSOLUTE)

unset(_VERSION)


#
# Section Platform
##########################################

set(_DECORATES_LIST "")

# Possible name is:
#   EXECUTABLE
#   IMPORT_LIBRARY
#   SHARED_LIBRARY
#   SHARED_MODULE
#   STATIC_LIBRARY
macro (__avr_decorate name prefix suffix)
    set(CMAKE_${name}_PREFIX ${prefix})
    set(CMAKE_${name}_SUFFIX ${suffix})
    list(APPEND _DECORATES_LIST ${name})
endmacro ()

__avr_decorate(EXECUTABLE     ""    ".elf")
__avr_decorate(STATIC_LIBRARY "lib" ".a")

set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" ".so")


#
# Section Platform-GNU
##########################################

find_library(_AR_PLUGIN_LTO NAMES lto_plugin PATHS ${AVR_TOOLCHAIN_AVR_DIR})

set(_AR_FLAGS "")

if (_AR_PLUGIN_LTO)
    set(_AR_FLAGS "--plugin ${_AR_PLUGIN_LTO}")
endif ()

macro(__avr_toolset_configure lang)
    foreach (name ${_DECORATES_LIST})
        set(CMAKE_${name}_PREFIX_${lang} ${CMAKE_${name}_PREFIX})
        set(CMAKE_${name}_SUFFIX_${lang} ${CMAKE_${name}_SUFFIX})
    endforeach ()

    set(CMAKE_${lang}_FLAGS                "")
    set(CMAKE_${lang}_FLAGS_DEBUG          "")
    set(CMAKE_${lang}_FLAGS_RELEASE        "")
    set(CMAKE_${lang}_FLAGS_MINSIZEREL     "")
    set(CMAKE_${lang}_FLAGS_RELWITHDEBINFO "")

    set(CMAKE_${lang}_COMPILE_OBJECT
        "<CMAKE_${lang}_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -o <OBJECT> -c <SOURCE>")
    set(CMAKE_${lang}_ARCHIVE_CREATE
        "<CMAKE_AR> qc ${_AR_FLAGS} <TARGET> <OBJECTS>")
    set(CMAKE_${lang}_ARCHIVE_APPEND
        "<CMAKE_AR> q ${_AR_FLAGS} <TARGET> <OBJECTS>")
    set(CMAKE_${lang}_ARCHIVE_FINISH
        "<CMAKE_RANLIB> ${_AR_FLAGS} <TARGET>")
    set(CMAKE_${lang}_LINK_EXECUTABLE
        "<CMAKE_${lang}_COMPILER> <LINK_FLAGS> <CMAKE_${lang}_LINK_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
endmacro()


#
# Section Platform-GNU-<LANG>
##########################################

__avr_toolset_configure(C)
__avr_toolset_configure(CXX)

unset(_DECORATES_LIST)

macro(avr_print_toolchain_status)
    message("[AVR GCC toolchain status]")
    message("  version           ${AVR_TOOLCHAIN_VERSION}")
    message("  install dir       ${AVR_TOOLCHAIN_ROOT_DIR}")
    message("  avr toolchain dir ${AVR_TOOLCHAIN_AVR_DIR}")
    message("  avr C compiler    ${AVR_TOOLCHAIN_C_COMPILER}")
    message("  avr C++ compiler  ${AVR_TOOLCHAIN_CXX_COMPILER}")
    message("  CMake C compiler     ${CMAKE_C_COMPILER}")
    message("  CMake C compiler id  ${CMAKE_C_COMPILER_ID}")
    message("  CMake C compiler ver ${CMAKE_C_COMPILER_VERSION}")
    message("  CMake C++ compiler     ${CMAKE_CXX_COMPILER}")
    message("  CMake C++ compiler id  ${CMAKE_CXX_COMPILER_ID}")
    message("  CMake C++ compiler ver ${CMAKE_CXX_COMPILER_VERSION}")
endmacro()
