#
# License: MIT
# Copyright (c) 2021 Nick Egorrov
#
#[=============================================================================[

#]=============================================================================]


macro(__avr_print_status status)
    if (NOT AVR_FIND_QUIETLY)
        message(STATUS "${status}")
    endif ()
endmacro()

macro(__avr_fatal_error error)
    set(AVR_NOT_FOUND_MESSAGE "AVR fatal error: ${error}")

    if (AVR_FIND_REQUIRED)
        message(FATAL_ERROR "${AVR_NOT_FOUND_MESSAGE}")
    endif ()

    return()
endmacro()


if (AVR_TOOLCHAIN_ID STREQUAL "GNU")
    foreach(component ${AVR_FIND_COMPONENTS})
        if (component STREQUAL "binutils")
            include(${CMAKE_CURRENT_LIST_DIR}/AVR-GCC-binutils.cmake)
        endif ()
    endforeach()

    foreach(component ${AVR_FIND_COMPONENTS})
        if (component STREQUAL "libc")
            include(${CMAKE_CURRENT_LIST_DIR}/AVR-GCC-libc.cmake)
        endif ()
    endforeach()

    include(${CMAKE_CURRENT_LIST_DIR}/AVR-GCC-helper.cmake)

    foreach(component ${AVR_FIND_COMPONENTS})
        if (component MATCHES "<([a-z0-9]+)>")
            avr_create_mcu(${CMAKE_MATCH_1})
        endif ()
    endforeach()
elseif (NOT AVR_COMPILER_ID)
    __avr_fatal_error("compiler not defined.")
else ()
    __avr_fatal_error("unknown compiler.")
endif ()

include(${CMAKE_CURRENT_LIST_DIR}/utils-debug.cmake)

set(AVR_FOUND TRUE)
