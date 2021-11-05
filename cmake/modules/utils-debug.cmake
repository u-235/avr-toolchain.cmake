#
# License: MIT
# Copyright (c) 2021 Nick Egorrov
#
#[=============================================================================[

#]=============================================================================]


if (__AVR_UTILS_DEBUG)
    return()
endif ()
set(__AVR_UTILS_DEBUG 1)

#[==============================[
#]==============================]
macro(avr_print_toolchain_status)
    message("[AVR GCC toolchain status]")
    message("  cmake toolchain version ${AVR_TOOLCHAIN_FILES_VERSION}")
    message("  id                      ${AVR_TOOLCHAIN_ID}")
    message("  GCC version             ${AVR_TOOLCHAIN_VERSION}")
    message("  install dir             ${AVR_TOOLCHAIN_ROOT_DIR}")
    message("  toolchain suffix        ${AVR_TOOLCHAIN_SUFFIX}")
    message("  avr C compiler          ${AVR_TOOLCHAIN_C_COMPILER}")
    message("  avr C++ compiler        ${AVR_TOOLCHAIN_CXX_COMPILER}")
    message("    CMake tools:")
    message("  CMake C compiler        ${CMAKE_C_COMPILER}")
    message("  CMake C compiler id     ${CMAKE_C_COMPILER_ID}")
    message("  CMake C compiler ver    ${CMAKE_C_COMPILER_VERSION}")
    message("  CMake C++ compiler      ${CMAKE_CXX_COMPILER}")
    message("  CMake C++ compiler id   ${CMAKE_CXX_COMPILER_ID}")
    message("  CMake C++ compiler ver  ${CMAKE_CXX_COMPILER_VERSION}")
endmacro()

#[==============================[
#]==============================]

macro(avr_print_binutils_status)
    message("[AVR GCC binutils status]")
    message("  id              ${AVR_BINUTILS_ID}")
    message("  version         ${AVR_BINUTILS_VERSION}")
    message("  install dir     ${AVR_BINUTILS_ROOT_DIR}")
    message("  binutils suffix ${AVR_BINUTILS_SUFFIX}")
    message("    AVR tools:")
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
    message("    CMake tools:")
    message("  CMake ar        ${CMAKE_AR}")
    message("  CMake linker    ${CMAKE_LINKER}")
    message("  CMake nm        ${CMAKE_NM}")
    message("  CMake objcopy   ${CMAKE_OBJCOPY}")
    message("  CMake objdump   ${CMAKE_OBJDUMP}")
    message("  CMake ranlib    ${CMAKE_RANLIB}")
    message("  CMake strip     ${CMAKE_STRIP}")
endmacro()

#[==============================[
#]==============================]
macro(avr_print_libc_status)
    message("[AVR GCC libc status]")
    message("  id              ${AVR_LIBC_ID}")
    message("  version         ${AVR_LIBC_VERSION}")
    message("  install dir     ${AVR_LIBC_ROOT_DIR}")
    message("  libc suffix     ${AVR_LIBC_SUFFIX}")
    message("  include dirs    ${AVR_LIBC_INCLUDE_DIRS}")
    message("  library dirs    ${AVR_LIBC_LIBRARY_DIRS}")
endmacro()

#[==============================[
#]==============================]
macro(avr_print_status)
    avr_print_toolchain_status()
    avr_print_binutils_status()
    avr_print_libc_status()
endmacro()
