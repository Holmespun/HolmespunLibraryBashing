# HolmespunLibraryBashing

The HolmespunLibraryBashing repository contains Bash library functions to solve common needs.

## Getting Started

The library can be used in repository clone form or it can be installed onto your system:

```bash
	git clone https://github.com/Holmespun/HolmespunLibraryBashing.git

	export PATH=${PWD}/HolmespunLibraryBashing/bin:${PATH}

	make test

	sudo make install
```

The repository bin directory should be added to your PATH if you plan to use the library in repository form.
If you install the library then the PATH variable need not be altered.

A rudimentary makefile is provided: You can use it to test the library code and/or to install the library.
Tests are run using the kamaji script (not included).
Kamaji is part of the [HolmespunTestingSupport](https://github.com/Holmespun/HolmespunTestingSupport/) repository.

## Using Library Code

A script that wants to use a library function will first source the file it is stored in.
To do so properly, the source command should call the *whereHolmespunLibraryBashing* script to locate the library.
The whereHolmespunLibraryBashing script displays the location of the library.

For example, the following source command may be used to gain access to the echoInColor functions:

```bash
	source $(whereHolmespunLibraryBashing)/Library/echoInColor.bash

	echoInColorGreen GO
	echoInColorYellow CAUTION
	echoInColorRed STOP
```

## Function Descriptions

Brief descriptions of every function provided.

### echoDatStampedFSpec.bash

#### echoDatStampedFSpec \<prefix\>

Append a Date And Time Stamp to a given Prefix to form a file specification, check to see that the
file does not exist, and if it does then increase the time portion of it name until a specification is
achieved that does not exist. Existence checking is only performed if the directory path of the
Prefix exists.

Example Code:

``` bash
	for index in 1 2 3; do touch $(echoDatStampedFSpec Walter_Bishop_); done
```

Example Output:

``` bash
	Walter_Bishop_20190908_113040
	Walter_Bishop_20190908_113041
	Walter_Bishop_20190908_113042
```

Three files created at roughly the same time (11:30:40) with three unique time stamps.

### echoInColor.bash

These functions use escape characters to display text in different colors.

```bash
	echo "Message Key: $(echoInColorRed Errors), $(echoInColorYellow Warnings), $(echoInColorGreen Swamp Things)." 
```

#### echoInColorBlue \<text\>

Displays text in blue font.

#### echoInColorGreen \<text\>

Displays text in green font.

#### echoInColorGreenBold \<text\>

Displays text in bold green font.

#### echoInColorRed \<text\>

Displays text in red font.

#### echoInColorRedBold \<text\>

Displays text in bold red font.

#### echoInColorWhite \<text\>

Displays text in white font.

#### echoInColorWhiteBold \<text\>

Displays text in bold white font.

#### echoInColorYellow \<text\>

Displays text in yellow font.


### echoRelativePath.bash

#### echoRelativePath \<from-file-specification\> \<to-file-specification\>

The echoRelativePath function within this file displays the relative directory that represents
the path between \<from-file-specification\> and \<to-file-specification\>; the specifications are
assumed to be comparable (e.g. both relative or both absolute). Current directory names are
ignored (i.e ".").  Undone directory names are also ignored (e.g. "name/..").

Example Code:

```bash
	echoRelativePath ./Working ../../Testing/data.text
```

Example Output:
```
	../../../Testing/data.text
```

### installHolmespunSoftware.bash

#### installHolmespunSoftware \<usr-bin-dspec\> \<opt-holmespun-dspec\>

Supports installation of the items in the Holmespun repositories.


### spit\_spite\_spitn\_and\_spew.bash

The spit, spite, spitn, and spew functions are the useful shortcut functions for text file population using Bash.
The echo command syntax is cumbersome when redirecting output, especially to one of several files.
These functions support a more object-oriented view of their functionality.

#### spit \<fspec\> \<word\>...

Uses echo command to append a line of words to the specified file.

#### spite \<fspec\> \<word\>...

Same as spit but with interpretation of escape sequences (e.g. \n).

#### spitn \<fspec\> \<word\>...

Same as spit but without adding an end-line character to the output.

#### spew \<fspec-target\> \<fspec-source\>...

Appends a set of specified source files to a specified target file.


## Copyright 2019 Brian G. Holmes

This README file is part of the Holmespun Testing Support repository.

The Holmespun Testing Support repository contains free software:
you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation,
either version 3 of the License, or (at your option) any later version.

The Holmespun Testing Support repository is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.
If not, see [<https://www.gnu.org/licenses/>](<https://www.gnu.org/licenses/>).

See the [COPYING.text](COPYING.text) file for further licensing information.

**(eof)**

