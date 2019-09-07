#----------------------------------------------------------------------------------------------------------------------
#
#  HolmespunLibraryBashing/Support/install_from_make.bash
#
#	Supports installation of the items in the HolmespunLibraryBashing repository.
#
#  Copyright 2019 Brian G. Holmes
#
#	This program is part of the Holmespun Makefile Method.
#
#	The Holmespun Makefile Method is free software: you can redistribute it and/or modify it under the terms of the
#	GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	The Holmespun Makefile Method is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
#	without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
#	Public License for more details.
#
#	You should have received a copy of the GNU General Public License along with this program.  If not, see
#	<https://www.gnu.org/licenses/>.
#
#  See the COPYING.text file for further information.
#
#  20190907 BGH; created.
#
#----------------------------------------------------------------------------------------------------------------------

set -u
set -e

umask 0002

#----------------------------------------------------------------------------------------------------------------------

declare -r DatStamp=$(date '+%Y%m%d_%H%M%S')

#----------------------------------------------------------------------------------------------------------------------

[ ! -d ${InstallLibraryDSpec} ] || mv ${InstallLibraryDSpec} ${InstallLibraryDSpec%/}.${DatStamp}.bak

mkdir --parents $(dirname ${InstallLibraryDSpec})

cp --recursive ./Library ${InstallLibraryDSpec}

InstallLibraryDSpec=$(cd ${InstallLibraryDSpec}; pwd)
InstallExecuteDSpec=$(cd ${InstallExecuteDSpec}; pwd)

declare -r UninstallFSpec=${InstallLibraryDSpec}/UNINSTALL.bash

echo "#!/bin/bash"									>> ${UninstallFSpec}
echo "#"										>> ${UninstallFSpec}
echo "#  ${UninstallFSpec}"								>> ${UninstallFSpec}
echo "#"										>> ${UninstallFSpec}
echo "#  Created by ${0}"								>> ${UninstallFSpec}
echo "#"										>> ${UninstallFSpec}
echo "mv ${InstallLibraryDSpec} ${InstallLibraryDSpec}.\$(date '+%Y%m%d_%H%M%S').bak"	>> ${UninstallFSpec}
echo "#"										>> ${UninstallFSpec}

declare BinFolderDSpec
declare BinFolderFLink
declare BinFolderFName
declare BinFolderFSpec

declare ActualExecuteDSpec
declare ActualExecuteFName
declare ActualExecuteFSpec

for BinFolderFSpec in ./bin/*
do
  #
  BinFolderFName=$(basename ${BinFolderFSpec})
  #
  BinFolderFLink=$(readlink ${BinFolderFSpec})
  #
  BinFolderDSpec=$(cd ${PWD}/bin/$(dirname ${BinFolderFLink}); pwd)
  #
  ActualExecuteFName=$(basename ${BinFolderFLink})
  #
  ActualExecuteDSpec=${InstallLibraryDSpec}/${BinFolderDSpec#${PWD}/Library}
  #
  ActualExecuteFSpec=${ActualExecuteDSpec}/${ActualExecuteFName}
  #
  LinkedExecuteFSpec=${InstallExecuteDSpec}/${BinFolderFName}
  #
  [ ! -L ${LinkedExecuteFSpec} ] && ln --symbolic ${ActualExecuteFSpec} ${LinkedExecuteFSpec}
  #
  echo "[ -L ${ActualExecuteFSpec} ] && rm ${ActualExecuteFSpec}"			>> ${UninstallFSpec}
  #
done

echo "#"										>> ${UninstallFSpec}
echo "#  (eof)"										>> ${UninstallFSpec}

chmod 755 ${UninstallFSpec}

#----------------------------------------------------------------------------------------------------------------------
