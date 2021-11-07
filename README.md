[RU]

----------------

# avr-gcc-toolchain.cmake

A kit for building AVR microcontroller software with CMake and AVR GCC toolchain.

- [Overview](#overview)
- [What will be required](#what-will-be-required)
- [Get started](#get-started)
- [Examples](#examples)
- [Licences](#licences)

## Overview

- An easy start. Just a few new commands with intuitive options.
- Ability to create libraries.

Firmware upload to the microcontroller is not supported and there are no plans to implement it yet.


## What will be required

CMake at least version 10. However, to use the `CMakePresets.json` presets file, version 20 or higher is required.

## Get started

It's easy:

- Copy the `cmake` folder to a convenient location, for example to the root of your project.
- In the main `CMakeLists.txt` add the `find_package` and the `avr_configure_mcu` commands with the required parameters, like this:

  ```cmake
  cmake_minimum_required(VERSION 3.10)
  project(nixie LANGUAGES C CXX)
  find_package(AVR REQUIRED binutils libc)
  avr_configure_mcu(
          atmega168
          NAME         MY_MCU
          DEFINES      F_CPU=16000000UL
          OPTIONS      -Os -ffunction-sections -fdata-sections
          LINK_OPTIONS -Wl,--gc-sections
  )
  ```
- By using `target_link_libraries` add the `MY_MCU` target to all targets that contain code for the microcontroller.
- When calling `cmake` to configure the project, add the option `-DCMAKE_TOOLCHAIN_FILE=path/to/avr-gcc-toolchain.cmake`.

See [documentation][doc] for details.


## Examples

As an example, see the use of this toolchain in the [nixie-in18] project.


## Licences

The source code of the scripts for CMake is distributed under the MIT license. For licensing of examples, see the relevant documentation.

[RU]: doc/README_ru.md
[doc]: USAGE.md "How to usage"

[nixie-in18]: https://github.com/u-235/nixie-in18
