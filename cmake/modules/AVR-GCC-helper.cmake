#
# License: MIT
# Copyright (c) 2021 Nick Egorrov
#
#[=============================================================================[
AVR helper
============
Several functions for easy handling of AVR specifics.

avr_create_mcu
    Creates an interface target for the MCU.
avr_configure_mcu
    Configures MCU.
avr_print_size
    Prints memory usage.
avr_get_firmware
    Gets the flash and EEPROM firmware.
#]=============================================================================]


if (__AVR_GCC_HELPER)
    return()
endif ()
set(__AVR_GCC_HELPER 1)

#[==============================[
Creates an interface target for the MCU.

Synopsis
------------
    avr_create_mcu(
        mcu
        [NAME name]
    )

Options
------------
mcu
    Specifies the MCU type.
    Also specifies the target name if NAME is not defined.
NAME name
    Optional, specifies the target name.
#]==============================]
function(avr_create_mcu mcu)
    cmake_parse_arguments(ARG "" "NAME" "" ${ARGN})

    if (NOT ARG_NAME)
        set(ARG_NAME ${mcu})
    endif ()

    add_library(${ARG_NAME} INTERFACE)
    set_target_properties(${ARG_NAME} PROPERTIES
        INTERFACE_COMPILE_OPTIONS -mmcu=${mcu}
        INTERFACE_LINK_OPTIONS -mmcu=${mcu}
        AVR_MCU_TYPE ${mcu})
endfunction()


#[==============================[
Configures MCU.

Synopsis
------------
    avr_configure_mcu(
        mcu
        [NAME name]
        [DEFINES <name | name=value> [...]]
        [OPTIONS option [...]]
        [LINK_OPTIONS option [...]]
    )

Options
------------
mcu
    Specifies the MCU type.
    Also specifies the target name if NAME is not defined.
NAME name
    Optional, specifies the target name.
DEFINES <name | name=value>
    Optional, adds definitions passed to the compiler with -D keys.
OPTIONS option
    Optional, adds options passed to the compiler.
LINK_OPTIONS option
    Optional, adds options passed to the linker.

Example
------------
    avr_configure_mcu(
        atmega168
        DEFINES      F_CPU=16000000
        OPTIONS      -Os -ffunction-sections -fdata-sections
        LINK_OPTIONS -Wl,--gc-sections
    )
#]==============================]
function(avr_configure_mcu mcu)
    cmake_parse_arguments(ARG "" "NAME" "DEFINES;OPTIONS;LINK_OPTIONS" ${ARGN})

    if (NOT ARG_NAME)
        set(ARG_NAME ${mcu})
    endif ()

    if (NOT TARGET ${ARG_NAME})
        avr_create_mcu(${mcu} NAME ${ARG_NAME})
    endif ()

    #target_include_directories(${ARG_NAME} INTERFACE ${AVR_LIBC_INCLUDE_DIRS})

    if (ARG_DEFINES)
        target_compile_definitions(${ARG_NAME} INTERFACE ${ARG_DEFINES})
    endif ()

    if (ARG_OPTIONS)
        target_compile_options(${ARG_NAME} INTERFACE ${ARG_OPTIONS})
    endif ()

    if (ARG_LINK_OPTIONS)
        target_link_options(${ARG_NAME} INTERFACE ${ARG_LINK_OPTIONS})
    endif ()
endfunction()


#[==============================[
Searches a MCU type among all linked libraries.

Synopsis
------------
    __avr_get_target_mcu_name(
        out_var
        target [...]
    )

The function searches for a target with the AVR_MCU_TYPE property and if it
finds one, it returns the value of that property. If the target has linked
libraries, then the search is performed for these libraries as well, recursively.

Options
------------
out_var
    Specifies the name of the variable in which the result will be placed.
target
    List of targets to search for MCU type.

Output
------------
The function returns type of the MCU on success or type-NOTFOUND on failure.

Example
------------
    __avr_get_target_mcu_type(
        name
        hal main
    )
#]==============================]
function(__avr_get_target_mcu_type out_var)
    set(type type-NOTFOUND)

    foreach(target ${ARGN})
        if (NOT TARGET ${target})
            continue()
        endif ()

        get_target_property(type ${target} AVR_MCU_TYPE)
        if (type)
            break()
        endif ()

        get_target_property(libs ${target} LINK_LIBRARIES)
        __avr_get_target_mcu_type(type ${libs})
        if (type)
            break()
        endif ()
    endforeach()

    set(${out_var} ${type} PARENT_SCOPE)
endfunction()


#[==============================[
Prints memory usage.

Synopsis
------------
    avr_print_size(
        target
    )

Options
------------
target
    Specifies the target. The target must be created with the add_executable
    command.

Example
------------
    avr_print_size(
        name
    )
#]==============================]
function(avr_print_size target)
    __avr_get_target_mcu_type(mcu ${target})
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${AVR_BINUTILS_SIZE}
         --mcu=${mcu} -C $<TARGET_FILE:${target}>
    )
endfunction()


#[==============================[
Gets the flash and EEPROM firmware.

Synopsis
------------
    avr_get_firmware(
        target
    )

The function extracts flash and EEPROM firmware from the target and saves them
in ${target}-flash.hex and ${target}-eeprom.hex files respectively. Currently
only ihex is supported as output format.

Options
------------
target
    Specifies the target. The target must be created with the add_executable
    command.

Example
------------
    avr_get_firmware(
        name
    )
#]==============================]
function(avr_get_firmware target)
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${AVR_BINUTILS_OBJCOPY}
        -R .eeprom -R .fuse -R .lock -R .signature -O ihex
        $<TARGET_FILE:${target}> ${target}-flash.hex
        COMMAND ${AVR_BINUTILS_OBJCOPY}
        -j .eeprom --no-change-warnings --change-section-lma .eeprom=0 -O ihex
        $<TARGET_FILE:${target}> ${target}-eeprom.hex
        BYPRODUCTS ${target}-flash.hex ${target}-eeprom.hex
        COMMENT "Extract hex for flash and eeprom"
    )
endfunction()
