# Holmespun Library Bashing Repository Library Files

This document briefly describes the files in the Library directory of the Holmespun Library Bashing (HLB) repository.

Library functions may be used by your own scripts by sourcing (a.k.a. including or importing) the library code.
For example:

~~~
source $(whereHolmespunLibraryBashing)/Library/copyToGarbage\_and\_moveToGarbage.bash
~~~

Use of the *whereHolmespunLibraryBashing* utility prevents the need to hardcode the location of the library,
but that utility is only available if you have installed the HLB repository,
or if you have the repository *bin* directory in your $PATH.

Table of Contents:

* [Garbage Directory](#garbage-directory)
* [[Library/copyToGarbage_and_moveToGarbage.bash](../Library/copyToGarbage_and_moveToGarbage.bash)](#library-copytogarbage_and_movetogarbage-bash---library-copytogarbage_and_movetogarbage-bash)>
[function copyToGarbage](#function-copytogarbage)
* [[Library/copyToGarbage_and_moveToGarbage.bash](../Library/copyToGarbage_and_moveToGarbage.bash)](#library-copytogarbage_and_movetogarbage-bash---library-copytogarbage_and_movetogarbage-bash)>
[function moveToGarbage](#function-movetogarbage)
* [[Library/echoAndExecute.bash](../Library/echoAndExecute.bash)](#library-echoandexecute-bash---library-echoandexecute-bash)>
[function echoAndExecute](#function-echoandexecute)
* [[Library/echoDatStampedFSpec.bash](../Library/echoDatStampedFSpec.bash)](#library-echodatstampedfspec-bash---library-echodatstampedfspec-bash)>
[function echoDatStampedFSpec](#function-echodatstampedfspec)
* [[Library/echoGarbageDSpec.bash](../Library/echoGarbageDSpec.bash)](#library-echogarbagedspec-bash---library-echogarbagedspec-bash)>
[function echoGarbageDSpec](#function-echogarbagedspec)
* [[Library/echoInColor.bash](../Library/echoInColor.bash)](#library-echoincolor-bash---library-echoincolor-bash)>
[function echoInColorBlue](#function-echoincolorblue)
* [[Library/echoInColor.bash](../Library/echoInColor.bash)](#library-echoincolor-bash---library-echoincolor-bash)>
[function echoInColorGreen](#function-echoincolorgreen)
* [[Library/echoInColor.bash](../Library/echoInColor.bash)](#library-echoincolor-bash---library-echoincolor-bash)>
[function echoInColorGreenBold](#function-echoincolorgreenbold)
* [[Library/echoInColor.bash](../Library/echoInColor.bash)](#library-echoincolor-bash---library-echoincolor-bash)>
[function echoInColorRed](#function-echoincolorred)
* [[Library/echoInColor.bash](../Library/echoInColor.bash)](#library-echoincolor-bash---library-echoincolor-bash)>
[function echoInColorRedBold](#function-echoincolorredbold)
* [[Library/echoInColor.bash](../Library/echoInColor.bash)](#library-echoincolor-bash---library-echoincolor-bash)>
[function echoInColorWhite](#function-echoincolorwhite)
* [[Library/echoInColor.bash](../Library/echoInColor.bash)](#library-echoincolor-bash---library-echoincolor-bash)>
[function echoInColorWhiteBold](#function-echoincolorwhitebold)
* [[Library/echoInColor.bash](../Library/echoInColor.bash)](#library-echoincolor-bash---library-echoincolor-bash)>
[function echoInColorYellow](#function-echoincoloryellow)
* [[Library/echoLocalArchiveNameFor.bash](../Library/echoLocalArchiveNameFor.bash)](#library-echolocalarchivenamefor-bash---library-echolocalarchivenamefor-bash)>
[function echoLocalArchiveNameFor](#function-echolocalarchivenamefor)
* [[Library/echoRelativePath.bash](../Library/echoRelativePath.bash)](#library-echorelativepath-bash---library-echorelativepath-bash)>
[function echoRelativePath](#function-echorelativepath)
* [[Library/installHolmespunSoftware.bash](../Library/installHolmespunSoftware.bash)](#library-installholmespunsoftware-bash---library-installholmespunsoftware-bash)>
[function installHolmespunSoftware](#function-installholmespunsoftware)
* [[Library/spit_spite_spitn_and_spew.bash](../Library/spit_spite_spitn_and_spew.bash)](#library-spit_spite_spitn_and_spew-bash---library-spit_spite_spitn_and_spew-bash)>
[function spit](#function-spit)
* [[Library/spit_spite_spitn_and_spew.bash](../Library/spit_spite_spitn_and_spew.bash)](#library-spit_spite_spitn_and_spew-bash---library-spit_spite_spitn_and_spew-bash)>
[function spite](#function-spite)
* [[Library/spit_spite_spitn_and_spew.bash](../Library/spit_spite_spitn_and_spew.bash)](#library-spit_spite_spitn_and_spew-bash---library-spit_spite_spitn_and_spew-bash)>
[function spitn](#function-spitn)
* [[Library/spit_spite_spitn_and_spew.bash](../Library/spit_spite_spitn_and_spew.bash)](#library-spit_spite_spitn_and_spew-bash---library-spit_spite_spitn_and_spew-bash)>
[function spew](#function-spew)
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


## [Library/copyToGarbage\_and\_moveToGarbage.bash](../Library/copyToGarbage_and_moveToGarbage.bash)

### function copyToGarbage

**USAGE: copyToGarbage [ &lt;file-specification&gt; ]...**

The copyToGarbage function copies one or more files to the garbage directory.
The fully-qualified name of each file is flattened into a target file name.
The files are copied into a subdirectory that has a year-month date stamp (YYYYMM format),
and each target file is given a date and time stamp prefix (YYYMMDD\_HHMMSS format).

The *cp* command used to fulfill each request is displayed to the user.
If the month subdirectory within the garbage directory does not exist then the function creates it; the mkdir command
is also displayed to the user.

The copyToGarbage function is used to implement the [copyToGarbage](../bin/copyToGarbage) utility:

``` bash
$ touch example1.txt Library/example2.txt
$ copyToGarbage example1.txt Library/example2.txt
mkdir --parents $HOME/Garbage/201910
cp --recursive --preserve example1.txt $HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.example1.txt
cp --recursive --preserve Library/example2.txt $HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.Library.example2.txt
$
```

### function moveToGarbage

**USAGE: moveToGarbage [ &lt;file-specification&gt; ]...**

The moveToGarbage function moves one or more files to the garbage directory.
The fully-qualified name of each file is flattened into a target file name.
The files are copied into a subdirectory that has a year-month date stamp (YYYYMM format),
and each target file is given a date and time stamp prefix (YYYMMDD\_HHMMSS format).

The *mv* command used to fulfill each request is displayed to the user.
If the month subdirectory within the garbage directory does not exist then the function creates it; the mkdir command
is also displayed to the user.

The moveToGarbage function is used to implement the [moveToGarbage](../bin/moveToGarbage) utility:

``` bash
$ touch example1.txt Library/example2.txt
$ moveToGarbage example1.txt Library/example2.txt
mkdir --parents $HOME/Garbage/201910
mv example1.txt $HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.example1.txt
mv Library/example2.txt $HOME/Garbage/201910/20191005_161222.Holmespun.HolmespunLibraryBashing.Library.example2.txt
$
```

## [Library/echoAndExecute.bash](../Library/echoAndExecute.bash)

### function echoAndExecute

**USAGE: echoAndExecute &lt;command&gt;**

The echoAndExecute function displays the command it is given before executing it.
If the command contains the name of the $HOME directory then it is masked before display.

``` bash
$ source Library/echoAndExecute.bash
$ echoAndExecute date '+%Y-%m-%d'
date +%Y-%m-%d
2019-10-05
$
```

## [Library/echoDatStampedFSpec.bash](../Library/echoDatStampedFSpec.bash)

### function echoDatStampedFSpec

**USAGE: echoDatStampedFSpec &lt;command&gt;**

The echoDatStampedFSpec function displays the given file specification prefix with a date and time stamp.

``` bash
$ source Library/echoDatStampedFSpec.bash
$ echoDatStampedFSpec Working/snapshot_
Working/snapshot_20191005_184850
```

The function also checks to see if the resulting specification represents an existing file;
if it does, then the time stamp is incremented by one, and the check is performed again.
This process may result in time stamps that do not represent normal clock values
(e.g. 60 and 61 seconds in the example below).

``` bash
$ for T in 1 2 3; do touch $(echoDatStampedFSpec Temporary_); done; ls -1 Temporary_*; date
Temporary_20191005_185559
Temporary_20191005_185560
Temporary_20191005_185561
Sat Oct  5 18:55:59 EDT 2019
$
```

## [Library/echoGarbageDSpec.bash](../Library/echoGarbageDSpec.bash)

### function echoGarbageDSpec

**USAGE: echoGarbageDSpec**

The echoGarbageDSpec function displays the specification of the garbage directory.
If the HOLMESPUN\_GARBAGE\_DSPEC variable is defined non-blank then its value will be returned.
Otherwise, if the GARBAGE variable is defined non-blank then its value will be returned.
Otherwise, the value ${HOME}/Garbage will be returned.

If the garbage directory represented by the specification to be returned does not exist,
then the function will not display that specification,
but instead it will generate an error message to /dev/stderr and return a non-zero value.

``` bash
$ echoGarbageDSpec | sed --expression="s,${HOME},\$HOME,"
$HOME/Garbage
$ export GARBAGE="/tmp/Trash"
$ echoGarbageDSpec
ERROR: The /tmp/Trash directory does not exist.
$ export HOLMESPUN_GARBAGE_DSPEC=/tmp
$ echoGarbageDSpec
/tmp
$
```

## [Library/echoInColor.bash](../Library/echoInColor.bash)

These functions use escape characters to display text in different colors.
Use of the escape sequences can be disabled by defining the HOLMESPUN\_MONOCHROMATIC variable.


``` bash
$ source Library/echoInColor.bash 
$ echo "Message Key: $(echoInColorRed Errors), $(echoInColorYellow Warnings), $(echoInColorGreen Swamp Things)." | od -c
0000000   M   e   s   s   a   g   e       K   e   y   :     033   [   3
0000020   8   ;   5   ;   9   m   E   r   r   o   r   s 033   [   0   m
0000040   ,     033   [   3   8   ;   5   ;   1   1   m   W   a   r   n
0000060   i   n   g   s 033   [   0   m   ,     033   [   3   8   ;   5
0000100   ;   1   0   m   S   w   a   m   p       T   h   i   n   g   s
0000120 033   [   0   m   .  \n
0000126
$ export HOLMESPUN_MONOCHROMATIC=
$ echo "Message Key: $(echoInColorRed Errors), $(echoInColorYellow Warnings), $(echoInColorGreen Swamp Things)."
Message Key: Errors, Warnings, Swamp Things.
$
```

### function echoInColorBlue
**USAGE: echoInColorBlue \<text\>**

Displays text in blue font.

### function echoInColorGreen
**USAGE: echoInColorGreen \<text\>**

Displays text in green font.

### function echoInColorGreenBold
**USAGE: echoInColorGreenBold \<text\>**

Displays text in bold green font.

### function echoInColorRed
**USAGE: echoInColorRed \<text\>**

Displays text in red font.

### function echoInColorRedBold
**USAGE: echoInColorRedBold \<text\>**

Displays text in bold red font.

### function echoInColorWhite
**USAGE: echoInColorWhite \<text\>**

Displays text in white font.

### function echoInColorWhiteBold
**USAGE: echoInColorWhiteBold \<text\>**

Displays text in bold white font.

### function echoInColorYellow
**USAGE: echoInColorYellow \<text\>**

Displays text in yellow font.

## [Library/echoLocalArchiveNameFor.bash](../Library/echoLocalArchiveNameFor.bash)

### function echoLocalArchiveNameFor

**USAGE: echoLocalArchiveNameFor &lt;file-specification&gt; [ &lt;date-and-time-stamp&gt; ]**

The echoLocalArchiveNameFor function constructs and displays an archive name based on the
file-specification it is given.
The specified file must exist;
otherwise, the resulting name will start with a period, and its quality and validity cannot be guaranteed.

The function will generate a stamp based on the current date-and-time, unless it is given one as a second parameter.
Resulting names have three parts:
The stamp; the absolute path of the file specified by the file-specification parameter;
and the file-specification parameter itself.
Any text to the left of and including the $USER name is removed from the absolute path part.
The three parts are concatenated using slash characters,
and then the entire string is modified in two ways:
All space characters are changed to underscore characters;
All groups of slashes are changed to periods.


``` bash
$ echoLocalArchiveNameFor myfile.text
20191005_215209.Holmespun.HolmespunLibraryBashing.myfile.text
$ echoLocalArchiveNameFor myfile.text 2019_10_05_215209
2019_10_05_215209.Holmespun.HolmespunLibraryBashing.myfile.text
$ echoLocalArchiveNameFor Testing/myfile.text
20191005_215443.Holmespun.HolmespunLibraryBashing.Testing.myfile.text
$ echoLocalArchiveNameFor Bogus/myfile.text
.20191005_221337.Holmespun.HolmespunLibraryBashing.Bogus.myfile.text
$
```

The echoLocalArchiveNameFor function is used by the copyToGarbage and moveToGarbage functions to generate file names
for use within the garbage directory.

## [Library/echoRelativePath.bash](../Library/echoRelativePath.bash)

### function echoRelativePath

**USAGE: echoRelativePath &lt;from-file-specification&gt; &lt;to-file-specification&gt;**

The echoRelativePath function displays the relative directory that represents the path between
the given from- and to-file-specification parameters.
The parameter specifications are assumed to be comparable (e.g. both relative or both absolute).
They need not exist, and no system validation is performed to fulfill this request.
Current directory names are
ignored (i.e ".").  Undone directory names are also ignored (e.g. "name/..").

``` bash
$ source Library/echoRelativePath.bash
$ echoRelativePath Testing/./Programs/../Data/ Working/
../../Working
$
```


## [Library/installHolmespunSoftware.bash](../Library/installHolmespunSoftware.bash)

### function installHolmespunSoftware

**USAGE: installHolmespunSoftware &lt;usr-bin-dspec&gt; &lt;opt-holmespun-dspec&gt; &lt;repository-dname&gt;
[ &lt;repository-fname&gt; ]...**

The installHolmespunSoftware function is used to install scripts and data from a repository that contains only those
things.
The function creates a representation of the repository-dname in the opt-holmespun-dspec, and
installs command utilities in the usr-bin-dspec.
Each file named as a repository-fname is also copied to the opt-holmespun-dspec.
As the function installs files, if also creates an UNINSTALL.bash script that can be used to remove or disable
the files it creates.

## [Library/spit\_spite\_spitn\_and\_spew.bash](../Library/spit_spite_spitn_and_spew.bash)

The spit, spite, spitn and spew commands may be the most useful bash functions you will ever call.
They each append data to a file, and require the caller to specify that file first.
In this way, calls to them have an almost object-oriented look which enhances the readability and quality of code.

``` bash
$ source Library/spit_spite_spitn_and_spew.bash 
$ spit  one.text "SPIT"
$ spite two.text "\tSPITE\n\tSPITE"
$ spitn two.text "SPITN"
$ spitn two.text "SPITN"
$ spite two.text "\tSPITE"
$ spew  three.text one.text two.text 
$ cat three.text 
SPIT
	SPITE
	SPITE
SPITNSPITN	SPITE
$
```

### function spit

**USAGE: spit \<target-fspec\> [ \<word\> ]...**

Uses the echo command to append a set of words to the specified file.

### function spite

**USAGE: spite \<target-fspec\> [ \<word\> ]...**

Same as spit but with interpretation of escape sequences (e.g. \n).

### function spitn

**USAGE: spitn \<target-fspec\> [ \<word\> ]...**

Same as spit but without adding an end-line character to the output.

### function spew

**USAGE: spew \<target-fspec\> \<source-fspec\>...**

Appends a set of specified source files to a specified target file.

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
