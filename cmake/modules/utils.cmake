#
# License: MIT
# Copyright (c) 2021 Nick Egorrov
#
#[=============================================================================[


#]=============================================================================]


if (__AVR_UTILS)
    return()
endif ()
set(__AVR_UTILS 1)

#[==============================[
Searches for a file in the specified folders.

Synopsis
---------
    __find_folder(
        module
        PATHS    path ...
        SUFFIXES suffix ...
        FILE     name
    )

The function searches for PATH/SUFFIX/FILE by going through PATHS and SUFFIXES.
In the example below, the search will be done in the following sequence:

- /usr/lib/avr
- /usr/libexec/avr
- /usr/local/lib/avr
- /usr/local/libexec/avr

If a file or directory is found in this example, the AVR_BINUTILS_ROOT_DIR
and AVR_BINUTILS_SUFFIX variables will be set.

Options
---------
module
    The name of the module that will be used to generate the variable names
    with the search results.
PATHS path ...
    A non-empty list of folders being searched. Use absolute paths to avoid
    ambiguity.
SUFFIXES <name | name=value>
    A non-empty list of suffixes. The blank suffix must be added explicitly
    if necessary.
FILE name
    The name of the file or directory you are looking for.

Output
---------
The AVR_${module}_ROOT_DIR and AVR_${module}_SUFFIX variables are changed
in the parent scope:

- If the file is found, the detected part from PATHS is written
  to the AVR_${module}_ROOT_DIR variable and the part from SUFFIXS is written
  to the AVR_${module}_SUFFIX variable.
- If the file is not found, file-NOTFOUND is written to both variables.

Examples
---------
    __find_folder(
        BINUTILS
        PATHS    /usr /usr/local
        SUFFIXES lib libexec
        FILE     avr
    )
#]==============================]
function(__find_folder module)
    cmake_parse_arguments(ARG "" "FILE" "PATHS;SUFFIXES" ${ARGN})

    foreach(path ${ARG_PATHS})
        foreach(suffix ${ARG_SUFFIXES})
            if (EXISTS ${path}/${suffix}/${ARG_FILE})
                set(AVR_${module}_ROOT_DIR ${path} PARENT_SCOPE)
                set(AVR_${module}_SUFFIX ${suffix} PARENT_SCOPE)
                return()
            endif ()
        endforeach()
    endforeach()

    set(AVR_${module}_ROOT_DIR "file-NOTFOUND" PARENT_SCOPE)
    set(AVR_${module}_SUFFIX   "file-NOTFOUND" PARENT_SCOPE)
endfunction()
