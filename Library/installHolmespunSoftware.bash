#----------------------------------------------------------------------------------------------------------------------
#
#  HolmespunLibraryBashing/Library/installHolmespunSoftware.bash
#
#	Supports installation of the items in the Holmespun repositories.
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

source $(whereHolmespunLibraryBashing)/Library/spit_spite_spitn_and_spew.bash

#----------------------------------------------------------------------------------------------------------------------

function installHolmespunSoftware() {
  #
  local -r GivenUsrBinDSpec=${1-/usr/bin}
  local -r GivenOptHpsDSpec=${2-/opt/holmespun}
  local -r GivenRepositoryDName=${3}
  shift 3
  local -r GivenRepositoryFList=${*}
  #
  local -r DatStamp=$(date '+%Y%m%d_%H%M%S')
  #
  #  Make sure we allow all users to access the files we create.
  #
  umask 0002
  #
  #  Convert any relative directory specifications to absolute ones.
  #
  mkdir --parents ${GivenUsrBinDSpec}/
  mkdir --parents ${GivenOptHpsDSpec}/
  #
  local -r AbsoluteOptHpsDSpec=$(cd ${GivenOptHpsDSpec}; pwd)/${GivenRepositoryDName}
  local -r AbsoluteUsrBinDSpec=$(cd ${GivenUsrBinDSpec}; pwd)
  #
  #  Uninstall the old OptHps installation if there is one.
  #
  local -r UninstallFSpec=${AbsoluteOptHpsDSpec}/UNINSTALL.bash
  #
  [ -x ${UninstallFSpec} ] && ${UninstallFSpec}
  #
  [ -d ${AbsoluteOptHpsDSpec} ] && mv ${AbsoluteOptHpsDSpec} ${AbsoluteOptHpsDSpec}.${DatStamp}.bak
  #
  #  Duplicate the repository of interest in the OptHps directory.
  #
  mkdir --parents ${AbsoluteOptHpsDSpec}/
  #
  cp --recursive ${GivenRepositoryFList} ${AbsoluteOptHpsDSpec}/
  #
  #  Create an uninstall script.
  #
  spit ${UninstallFSpec} "#!/bin/bash"
  spit ${UninstallFSpec} "#"
  spit ${UninstallFSpec} "#  ${UninstallFSpec}"
  spit ${UninstallFSpec} "#"
  spit ${UninstallFSpec} "#  Created by ${FUNCNAME}"
  spit ${UninstallFSpec} "#"
  spit ${UninstallFSpec} ""
  spit ${UninstallFSpec} "mv ${AbsoluteOptHpsDSpec} ${AbsoluteOptHpsDSpec}.\$(date '+%Y%m%d_%H%M%S').bak"
  #
  #  Create a UsrBin link to each file in the OptHps bin directory.
  #
  local SourceFSpec TargetFSpec SourceFName LinkedFSpec LinkedDSpec LinkedFName
  #
  for SourceFSpec in ./bin/*
  do
    #
    [ ! -L ${SourceFSpec} ] && continue
    #
    SourceFName=$(basename ${SourceFSpec})
    #
    TargetFSpec=${AbsoluteUsrBinDSpec}/${SourceFName}
    #
    rm --force ${TargetFSpec}
    #
    if [ "${SourceFName:0:14}" = "whereHolmespun" ]
    then
       #
       spit ${TargetFSpec} "#!/bin/bash"
       spit ${TargetFSpec} "echo ${AbsoluteOptHpsDSpec}"
       #
       chmod 755 ${TargetFSpec}
       #
    else
       #
       LinkedFSpec=$(readlink ${SourceFSpec})
       #
       LinkedDSpec=$(cd bin/$(dirname ${LinkedFSpec}); pwd)
       LinkedFName=$(basename ${LinkedFSpec})
       #
       ln --symbolic ${AbsoluteOptHpsDSpec}/${LinkedDSpec#${PWD}}/${LinkedFName} ${TargetFSpec}
       #
    fi
    #
    spit ${UninstallFSpec} ""
    spit ${UninstallFSpec} "rm --force ${TargetFSpec}"
    #
  done
  #
  spit ${UninstallFSpec} ""
  spit ${UninstallFSpec} "#"
  spit ${UninstallFSpec} "#  (eof)"
  #
  chmod 755 ${UninstallFSpec}
  #
  true
  #
}

#----------------------------------------------------------------------------------------------------------------------
