# Holmespun Library Bashing Repository Library Files

This document briefly describes the utilities available in the Holmespun Library Bashing (HLB) repository.
These utilities can be used as commands if you have installed the HLB repository,
or if you have the repository *bin* directory in your $PATH.

Table of Contents:

* [Garbage Directory](#garbage-directory)
* [copyToGarbage](#copytogarbage)
* [doxygenFilterForBashToCxx](#doxygenfilterforbashtocxx)
* [generateMarkdownTocLinksFor](#generatemarkdowntoclinksfor)
* [moveToGarbage](#movetogarbage)
* [sedSubstituteEachFile](#sedsubstituteeachfile)
* [whereHolmespunLibraryBashing](#whereholmespunlibrarybashing)
* [wordsNotKnown](#wordsnotknown)
* [Copyright](#copyright)

Document History:
* 2019-10-06 BGH: First version.

## Garbage Directory

Several of the functions defined in this library support the concept of a *garbage* directory.
A garbage directory is a location that is used to store backup and potentially deletable files.
The garbage directory serves as an archive for files whose usefulness quickly diminishes over time.

When a user is smart enough to backup their files then
the garbage directory serves as an organized location in which those backups can be found.

Accidental misuse of the *rm* command can be devastating.
Instead of deleting files with the rm command they should be moved to the garbage directory;
there they can stay until the decision of whether or not to delete them is a trivial one.

The garbage directory supported here stores files in a shallow, year- and month-based hierarchy.
The hierarchy makes it easy to delete files that are roughly the same age.

The copyToGarbage and moveToGarbage functions generate archive file names:
Every name contains a date-and-time stamp based on when it was copied or moved into the directory; and
the original directory path is expressed in the name.
These file names make it easy to search and extract specific files.

By default, the $HOME/Garbage directory is used as a garbage directory.
Users can define another location by setting either of the
HOLMESPUN\_GARBAGE\_DSPEC or GARBAGE variables to the directory that they prefer to use.


## copyToGarbage

**USAGE: [copyToGarbage](../bin/copyToGarbage) [ &lt;file-specification&gt; ]...**

The copyToGarbage utility copies one or more files to the garbage directory.
The fully-qualified name of each file is flattened into a garbage archive file name.
The files are copied into a subdirectory that has a year-month date stamp (YYYYMM format),
and each target file is given a date and time stamp prefix (YYYMMDD\_HHMMSS format).

The *cp* command used to fulfill each request is displayed to the user.
If the year-month subdirectory within the garbage directory does not exist then the utility creates it
and displays the mkdir command.

``` bash
$ touch example1.txt Library/example2.txt
$ copyToGarbage example1.txt Library/example2.txt
mkdir --parents $HOME/Garbage/201910
cp --recursive --preserve example1.txt $HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.example1.txt
cp --recursive --preserve Library/example2.txt $HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.Library.example2.txt
$ find $HOME/Garbage -name 20191005* | sed --expression="s,$HOME,\$HOME,"
$HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.Library.example2.txt
$HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.example1.txt
$
```

## doxygenFilterForBashToCxx

**USAGE: [doxygenFilterForBashToCxx](../bin/doxygenFilterForBashToCxx) \<source-fspec\>**

Translates the specified Bash script into a form that the doxygen program can interpret as C++ code.
The result is written to /dev/stdout.
Doxygen special comments are preserved in the translation.

This function was created for use in a doxygen configuration file so that doxygen can use it to translate Bash scripts:

```
# The FILTER_PATTERNS tag can be used to specify filters on a per file pattern
# basis. Doxygen will compare the file name with each pattern and apply the
# filter if there is a match. The filters are a list of the form: pattern=filter
# (like *.cpp=my_cpp_filter). See INPUT_FILTER for further information on how
# filters are used. If the FILTER_PATTERNS tag is empty or if none of the
# patterns match the file name, INPUT_FILTER is applied.
#
# Note that for custom extensions or not directly supported extensions you also
# need to set EXTENSION_MAPPING for the extension otherwise the files are not
# properly processed by doxygen.

FILTER_PATTERNS        = *.bash=doxygenFilterForBashToCxx

# Doxygen selects the parser to use depending on the extension of the files it
# parses. With this tag you can assign which parser to use for a given
# extension. Doxygen has a built-in mapping, but you can override or extend it
# using this tag. The format is ext=language, where ext is a file extension, and
# language is one of the parsers supported by doxygen: IDL, Java, Javascript,
# C#, C, C++, D, PHP, Objective-C, Python, Fortran (fixed format Fortran:
# FortranFixed, free formatted Fortran: FortranFree, unknown formatted Fortran:
# Fortran. In the later case the parser tries to guess whether the code is fixed
# or free formatted code, this is the default for Fortran type files), VHDL. For
# instance to make doxygen treat .inc files as Fortran files (default is PHP),
# and .f files as C (default is Fortran), use: inc=Fortran f=C.
#
# Note: For files without extension you can use no_extension as a placeholder.
#
# Note that for custom extensions you also need to set FILE\_PATTERNS otherwise
# the files are not read by doxygen.

EXTENSION_MAPPING      = bash=C++
```

The doxygenFilterForBashToCxx utility was inspired by work described at
[https://github.com/Anvil/bash-doxygen/](https://github.com/Anvil/bash-doxygen/).


## generateMarkdownTocLinksFor

**USAGE: [generateMarkdownTocLinksFor](../bin/generateMarkdownTocLinksFor) \<markdown-fspec\> [ \<header-level\> ]**

The generateMarkdownTocLinksFor utility displays a Table Of Contents (TOC) based on the headers of a markdown document.
The TOC is defined by links to targets that will be automatically generated when the markdown is rendered in HTML.
The displayed result is in markdown format.

One TOC bullet-point line is generated for every header that represents a section that has no sub-headers.
The line produced for a nested header will contain links to each of its parent headers.

The TOC for this and every markdown document in this repository was created by applying the generateMarkdownTocLinksFor
utility to the document, and then pasting the results into the document.

The header-level parameter allows the user to control the starting header level/nesting for which TOC lines should be
generated.
The default header-level is 2 because that suits documents, like this one, where a single top-level header represents
the document title.

``` bash
$ rm example.md 
$ spit example.md "# Example Document"
$ spit example.md "## Overview"
$ spit example.md "## Color Codes"
$ spit example.md "### Red"
$ spit example.md "### Blue"
$ cat example.md 
# Example Document
## Overview
## History
## Color Codes
### Red
### Blue
$ bin/generateMarkdownTocLinksFor example.md
* [Overview](#overview)
* [Color Codes](#color-codes)>
[Red](#red)
* [Color Codes](#color-codes)>
[Blue](#blue)
$
```

## moveToGarbage

**USAGE: [moveToGarbage](../bin/moveToGarbage) [ &lt;file-specification&gt; ]...**

The moveToGarbage utility copies one or more files to the garbage directory.
The fully-qualified name of each file is flattened into a garbage archive file name.
The files are copied into a subdirectory that has a year-month date stamp (YYYYMM format),
and each target file is given a date and time stamp prefix (YYYMMDD\_HHMMSS format).

The *mv* command used to fulfill each request is displayed to the user.
If the year-month subdirectory within the garbage directory does not exist then the utility creates it
and displays the mkdir command.

``` bash
$ touch example1.txt Library/example2.txt
$ moveToGarbage example1.txt Library/example2.txt
mkdir --parents $HOME/Garbage/201910
mv example1.txt $HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.example1.txt
mv Library/example2.txt $HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.Library.example2.txt
$ find $HOME/Garbage -name 20191005* | sed --expression="s,$HOME,\$HOME,"
$HOME/Garbage/201910/20191005\_161222.Holmespun.HolmespunLibraryBashing.Library.example2.txt
$HOME/Garbage/201910/20191005\_161222.Holmespun.HolmespunLibraryBashing.example1.txt
$
```


## sedSubstituteEachFile

**USAGE: [sedSubstituteEachFile](../bin/sedSubstituteEachFile) \<target\> \<replacement\> \<fspec\>...**

A utility that applies a *sed* substitute command to the contents and names of the specified files.
The *target* regular expression and *replacement* text are applied as *sed --expression='s,<target>,<replacement>,g'*.
The utility may or may not change the contents of each file, and
may or may not rename each file, but will always report those changes when they occur.

``` bash
$ source Library/spit_spite_spitn_and_spew.bash 
$ spit MyClass.hpp "# ifndef __MyClass"
$ spit MyClass.hpp "# define __MyClass"
$ spit MyClass.hpp "class MyClass {"
$ spit MyClass.hpp "..."
$ spit MyClass.hpp "};"
$ spit MyClass.hpp "# endif"
$ sedSubstituteEachFile MyClass CommPacket *hpp
MyClass.hpp (changed,renamed)
$ cat CommPacket.hpp 
# ifndef __CommPacket
# define __CommPacket
class CommPacket {
...
};
# endif
$
```

## whereHolmespunLibraryBashing

**USAGE: [whereHolmespunLibraryBashing](../bin/whereHolmespunLibraryBashing)**

The whereHolmespunLibraryBashing utility can be used to locate the library code of this repository.
The utility will display the directory specification of the repository or its installed representation.


## wordsNotKnown

**USAGE: [wordsNotKnown](../bin/wordsNotKnown) \<file-specification\>...**

Checking the spelling of code and document files can be a problem
because the syntax and format introduce *words* that do not appear in other written forms.
These syntax and format words get in the way of evaluating the other kinds of words that may actually be misspelled.
The wordsNotKnown utility allows you to mask away
those syntax and format words so that checking the spelling of all of the other words is easy and fruitful.

The wordsNotKnown utility reports all of the words that it does not know in the specified files.
The utility uses the aspell command.
The utility output is a list of words that it does not know; one word per line.

The utility can learn words by placing them in a configuration file.
Configuration files are named .wordsNotKnown.conf and are search for in both the current and $HOME directories.
These files contain any number of words separated by whitespace in plain text format.

``` bash
$ source Library/spit_spite_spitn_and_spew.bash
$ spit despair.com "Cluelessness: There are no stupid questions, but there are a lot of inquisitive idiots."
$ wordsNotKnown despair.com 
wordsNotKnown...
================
Cluelessness...
despair.com:Cluelessness: There are no stupid questions, but there are a lot of inquisitive idiots.
================
$ spit .wordsNotKnown.conf Cluelessness
$ wordsNotKnown despair.com 
wordsNotKnown...
================
All words are known.
================
$
```

The files in each of the Holmespun repositories are checked as follows:

``` bash
	wordsNotKnown $(find . -type f | grep -v Working | grep -v "\.git" | sort)
```

##  Copyright

Copyright (c) 2019 Brian G. Holmes

This program is part of the Holmespun Library Bashing repository.

The Holmespun Library Bashing repository contains free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.

The Holmespun Library Bashing repository is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along with this file. If not, see
[<https://www.gnu.org/licenses/>](<https://www.gnu.org/licenses/>).

See the [COPYING.text](COPYING.text) file for further information.

**(eof)**
