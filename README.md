# HolmespunLibraryBashing

The HolmespunLibraryBashing repository contains Bash library functions and utilities to solve common needs.

## Related Documents

Please refer to these documents for details on what is available in this repository, and how to use it.

* [Library](Documen/Library.md) files and the functions they contain.
* [Utility](Documen/Utility.md) scripts that may be used as commands.


## Getting Started

The library can be used in repository form or it can be installed onto your system.

### Clone
In either case, you need to clone the repository, and then add its *bin* directory to your $PATH:

``` bash
	git clone https://github.com/Holmespun/HolmespunLibraryBashing.git

	export PATH=${PWD}/HolmespunLibraryBashing/bin:${PATH}
```

### Test (Optional)

If you want to run the repository tests then you will also need to clone the
[HolmespunTestingSupport](https://github.com/Holmespun/HolmespunTestingSupport/) repository.
Once that repository is available, the tests can be run via the *make* command:

``` bash
	make test
```

### Configure (Optional)

The [.bash.conf](.bash.conf) file contains variable and alias definitions for use with this code:

``` bash
	export PATH=${PWD}/HolmespunLibraryBashing/bin:${PATH}

	source $(whereHolmespunLibraryBashing)/.bash.conf
```

The *whereHolmespunLibraryBashing* command allows you to avoid hardcoding the repository location.
The source command above is valid whether or not you have installed the repository.

### Install (Optional)

Installing the repository is equally easy:

``` bash
	sudo make install

	export PATH=${PATH//HolmespunLibraryBashing/HLB_DISABLED}
```

You should remove the location of the repository from your $PATH after it has been installed.

After installation, the repository will be represented in the /opt/holmespun directory,
and each of its utilities will be represented in the /usr/bin directory.

### Uninstall (Optional)

An installed repository can be uninstalled using a script that is created during the installation process.

``` bash
	sudo /opt/holmespun/HolmespunTestingSupport/UNINSTALL.bash
```

The UNINSTALL.bash script performs two main functions:
It renames the directory it which it resides; and
It removes the /usr/bin files that were created by the install process.

## Copyright

Copyright (c) 2019 Brian G. Holmes

This program is part of the Holmespun Library Bashing repository.

The Holmespun Library Bashing repository contains free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.

The Holmespun Library Bashing repository is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along with this file.
If not, see [<https://www.gnu.org/licenses/>](<https://www.gnu.org/licenses/>).

See the [COPYING.text](COPYING.text) file for further licensing information.

**(eof)**

