#
# License: MIT
# Copyright (c) 2021 Nick Egorrov
#
#[=============================================================================[

The following variables are changed in this module:

- AVR_BINUTILS_ID      = GNU
- AVR_BINUTILS_VERSION
- AVR_BINUTILS_ROOT_DIR in Linux usually /usr or /usr/local
- AVR_BINUTILS_AVR_DIR  = ${AVR_BINUTILS_ROOT_DIR}/lib/avr

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

macro(__find_programm var name)
    find_program(AVR_BINUTILS_${var} avr-${name} REQUIRED)
    get_filename_component(AVR_BINUTILS_${var} "${AVR_BINUTILS_${var}}" REALPATH)
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

get_filename_component(AVR_BINUTILS_AVR_DIR "${AVR_BINUTILS_AS}" REALPATH)
get_filename_component(AVR_BINUTILS_AVR_DIR "${AVR_BINUTILS_AVR_DIR}" DIRECTORY)
get_filename_component(AVR_BINUTILS_AVR_DIR "${AVR_BINUTILS_AVR_DIR}/../" ABSOLUTE)
get_filename_component(AVR_BINUTILS_ROOT_DIR "${AVR_BINUTILS_AVR_DIR}/../../" ABSOLUTE)

set(CMAKE_AR       ${AVR_BINUTILS_AR})
set(CMAKE_LINKER   ${AVR_BINUTILS_LD})
set(CMAKE_NM       ${AVR_BINUTILS_NM})
set(CMAKE_OBJCOPY  ${AVR_BINUTILS_OBJCOPY})
set(CMAKE_OBJDUMP  ${AVR_BINUTILS_OBJDUMP})
set(CMAKE_RANLIB   ${AVR_BINUTILS_RANLIB})
set(CMAKE_STRIP    ${AVR_BINUTILS_STRIP})

__avr_print_status("Found GNU binutils for AVR version ${AVR_BINUTILS_VERSION}")

macro(avr_print_binutils_status)
    message("[AVR GCC binutils status]")
    message("  version          ${AVR_BINUTILS_VERSION}")
    message("  install dir      ${AVR_BINUTILS_ROOT_DIR}")
    message("  avr binutils dir ${AVR_BINUTILS_AVR_DIR}")

    message("  avr-ar      ${AVR_BINUTILS_AR}")
    message("  avr-as      ${AVR_BINUTILS_AS}")
    message("  avr-c++flit ${AVR_BINUTILS_CXXFILT}")
    message("  avr-elfedit ${AVR_BINUTILS_ELFEDIT}")
    message("  avr-gprof   ${AVR_BINUTILS_GPROF}")
    message("  avr-ld      ${AVR_BINUTILS_LD}")
    message("  avr-ld.bfd  ${AVR_BINUTILS_LD_BFD}")
    message("  avr-nm      ${AVR_BINUTILS_NM}")
    message("  avr-objcopy ${AVR_BINUTILS_OBJCOPY}")
    message("  avr-objdump ${AVR_BINUTILS_OBJDUMP}")
    message("  avr-ranlib  ${AVR_BINUTILS_RANLIB}")
    message("  avr-readelf ${AVR_BINUTILS_READELF}")
    message("  avr-size    ${AVR_BINUTILS_SIZE}")
    message("  avr-strings ${AVR_BINUTILS_STRINGS}")
    message("  avr-strip   ${AVR_BINUTILS_STRIP}")

    message("  CMake ar      ${CMAKE_AR}")
    message("  CMake linker  ${CMAKE_LINKER}")
    message("  CMake nm      ${CMAKE_NM}")
    message("  CMake objcopy ${CMAKE_OBJCOPY}")
    message("  CMake objdump ${CMAKE_OBJDUMP}")
    message("  CMake ranlib  ${CMAKE_RANLIB}")
    message("  CMake strip   ${CMAKE_STRIP}")
endmacro()
