#
# License: MIT
# Copyright (c) 2021 Nick Egorrov
#
#[=============================================================================[

The following variables are changed in this module:

- AVR_BINUTILS_ID      = GNU
- AVR_BINUTILS_VERSION
- AVR_BINUTILS_ROOT_DIR in Linux usually /usr or /usr/local
- AVR_BINUTILS_SUFFIX   = lib/avr or avr

- AVR_BINUTILS_AR
- AVR_BINUTILS_AS
- AVR_BINUTILS_CXXFILT
- AVR_BINUTILS_ELFEDIT
- AVR_BINUTILS_GPROF
- AVR_BINUTILS_LD
- AVR_BINUTILS_LD_BFD
- AVR_BINUTILS_NM
- AVR_BINUTILS_OBJCOPY
- AVR_BINUTILS_OBJDUMP
- AVR_BINUTILS_RANLIB
- AVR_BINUTILS_READELF
- AVR_BINUTILS_SIZE
- AVR_BINUTILS_STRINGS
- AVR_BINUTILS_STRIP

- CMAKE_AR
- CMAKE_LINKER
- CMAKE_NM
- CMAKE_OBJCOPY
- CMAKE_OBJDUMP
- CMAKE_RANLIB
- CMAKE_STRIP

#]=============================================================================]


if (__AVR_GCC_BINUTILS)
    return()
endif ()
set(__AVR_GCC_BINUTILS 1)

set(AVR_BINUTILS_ID GNU)

include(${CMAKE_CURRENT_LIST_DIR}/utils.cmake)

__find_folder(BINUTILS PATHS ${AVR_PREFIX_PATH} SUFFIXES libexec/avr lib/avr avr FILE bin)

if (NOT AVR_BINUTILS_ROOT_DIR)
    __avr_fatal_error("could not find binutils")
endif ()

macro(__find_programm var name)
    find_program(AVR_BINUTILS_${var}
            NAMES avr-${name} ${name}
            HINTS ${AVR_BINUTILS_ROOT_DIR}/${AVR_BINUTILS_SUFFIX} ${AVR_BINUTILS_ROOT_DIR}
            PATH_SUFFIXES bin
            NO_CMAKE_ENVIRONMENT_PATH
            NO_CMAKE_PATH
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_SYSTEM_PATH)
endmacro()

foreach( arg
        "AR;ar" "AS;as" "CXXFILT;c++filt" "ELFEDIT;elfedit" "GPROF;gprof"
        "LD;ld" "LD_BFD;ld.bfd" "NM;nm" "OBJCOPY;objcopy" "OBJDUMP;objdump"
        "RANLIB;ranlib" "READELF;readelf" "SIZE;size" "STRINGS;strings"
        "STRIP;strip")
    __find_programm(${arg})
endforeach()

execute_process(COMMAND ${AVR_BINUTILS_AS} --version OUTPUT_VARIABLE _VERSION ERROR_VARIABLE _VERSION)

if("${_VERSION}" MATCHES "\\(.*\\) ([0-9]+\\.[0-9]+)")
    set(AVR_BINUTILS_VERSION ${CMAKE_MATCH_1})
endif()
unset(_VERSION)

if (AVR_BINUTILS_REDEFINE)
    set(CMAKE_AR       ${AVR_BINUTILS_AR})
    set(CMAKE_LINKER   ${AVR_BINUTILS_LD})
    set(CMAKE_NM       ${AVR_BINUTILS_NM})
    set(CMAKE_OBJCOPY  ${AVR_BINUTILS_OBJCOPY})
    set(CMAKE_OBJDUMP  ${AVR_BINUTILS_OBJDUMP})
    set(CMAKE_RANLIB   ${AVR_BINUTILS_RANLIB})
    set(CMAKE_STRIP    ${AVR_BINUTILS_STRIP})
endif ()

__avr_print_status("Found GNU binutils for AVR version ${AVR_BINUTILS_VERSION}")
