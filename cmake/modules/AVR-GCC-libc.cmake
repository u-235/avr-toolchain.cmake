#
# License: MIT
# Copyright (c) 2021 Nick Egorrov
#
#[=============================================================================[

The following variables are changed in this module:

- AVR_LIBC_ID       = GNU
- AVR_LIBC_VERSION
- AVR_LIBC_ROOT_DIR in Linux usually /usr or /usr/local
- AVR_LIBC_SUFFIX   = lib/avr or avr

- AVR_LIBC_INCLUDE_DIRS
- AVR_LIBC_LIBRARY_DIRS

#]=============================================================================]


if (__AVR_GCC_LIBC)
    return()
endif ()
set(__AVR_GCC_LIBC 1)

set(AVR_LIBC_ID GNU)

include(${CMAKE_CURRENT_LIST_DIR}/utils.cmake)

__find_folder(LIBC PATHS ${AVR_PREFIX_PATH} SUFFIXES lib/avr avr FILE include/avr/version.h)

if (NOT AVR_LIBC_ROOT_DIR)
    __avr_fatal_error("could not find the file \"avr/version.h\"")
endif ()

file(READ "${AVR_LIBC_ROOT_DIR}/${AVR_LIBC_SUFFIX}/include/avr/version.h" _VERSION_H)

string(REGEX MATCH
        [[#define[ \t]*__AVR_LIBC_VERSION_STRING__[ \t]*"([0-9\.]*)[a-zA-Z]*"]]
        _DUMP ${_VERSION_H})

if (CMAKE_MATCH_COUNT)
    set(AVR_LIBC_VERSION ${CMAKE_MATCH_1})
else ()
    __avr_fatal_error("could not read version in file \"avr/version.h\"")
endif ()

unset(_VERSION_H)
unset(_DUMP)
set(AVR_LIBC_INCLUDE_DIRS ${AVR_LIBC_ROOT_DIR}/${AVR_LIBC_SUFFIX}/include)
set(AVR_LIBC_LIBRARY_DIRS ${AVR_LIBC_ROOT_DIR}/${AVR_LIBC_SUFFIX}/lib)

__avr_print_status("Found libc for AVR version ${AVR_LIBC_VERSION}")
