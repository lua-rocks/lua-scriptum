# lua-scriptum

## Vignette

**Title**:
lua-scriptum

**Version**:
1.0

**Description**:
Document generator for Lua based code;
The output files are in markdown syntax

**Authors**:
Charles Mallah

**Copyright**:
(c) 2020 Charles Mallah

**License**:
MIT license (mit-license.org)

**Sample**:
Output is in markdown

    This document was created with this module, view the source file to see example input
    And see the raw readme.md for example output

**Example**:
Generate all documentation from the root directory

    local scriptum = require("scriptum")
    scriptum.start()

**Example**:
Create an optional header vignette with a comment block and these tags (all optional):
- **@title** the name of the file/module (once, single line)
- **@version** the current version (once, single line)
- **@description** module description (once, multiple lines)
- **@authors** the authors (once, single line)
- **@copyright** the copyright line (once, single line)
- **@license** the license (once, single line)
- **@sample** provide sample outputs (multiple entries, multiple lines)
- **@example** provide usage examples (multiple entries, multiple lines)

Such as the following:

    --[[
    @title Test Module
    @version 1.0
    @authors Mr. Munki
    @example Import and run with start()
    `local module = require("testmodule")
    `module.start()
    ]]

Backtic is used to mark a line as a code block when written in markdown.
Empty lines can be used if required as to your preference.

**Example**:
Create an API function entry with a comment block and one of more of:

    @param name (typing) <default> [note]
Where:
- **name** is the param
- **(typing)** such as (boolean), (number), (function), (string)
- **\<default\>** is the default value; if optional put \<nil\>; or \<required\> if so
- **[note]** is any further information

Such as any of the following:

    @param filename (string) <required> [File will be created and overwritten]
    @param filename (string) <default: "profiler.log"> [File will be created and overwritten]
    @param filename (string)

Return values can be included inside the comment block with:

    @return name (typing) [note]

Such as:

    @return success (boolean) [Fail will be handled gracefully and return false]
    @return success (boolean)

**Example**:
The markup used in this file requres escape symbols to generate the outputs properly:
- Where **()** with **start** or **end** can be used to escape block comments open and close.
- Angled brackets are escaped with \\< and \\>

## API

**start** (rootPath) : x1, x2  

> Start document generation  
> &rarr; **rootPath** (string) <*required*> `Path that will contain the generated documentation`  
> &larr; **x1** (boolean) `Testing for output`  
> &larr; **x2** (number)  
