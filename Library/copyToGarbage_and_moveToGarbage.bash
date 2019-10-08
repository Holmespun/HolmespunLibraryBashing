#----------------------------------------------------------------------------------------------------------------------
###
###	Library/copyToGarbage_and_moveToGarbage.bash
###
###  @file
###  @author	Brian G. Holmes
###  @copyright	GNU General Public License
###  @brief	Define functions that can be used to copy and move files to a location where they can be safely deleted
###		at a later time.
###
#----------------------------------------------------------------------------------------------------------------------
#	
#  Copyright (c) 2001-2019 Brian G. Holmes
#
#	This program is part of the Holmespun Library Bashing repository.
#
#	The Holmespun Library Bashing repository contains free software: you can redistribute it and/or modify it under
#	the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of
#	the License, or (at your option) any later version.
#
#	The Holmespun Library Bashing repository is distributed in the hope that it will be useful, but WITHOUT ANY
#	WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#	General Public License for more details.
#
#	You should have received a copy of the GNU General Public License along with this file. If not, see
#       <https://www.gnu.org/licenses/>.
#
#  See the COPYING.text file for further information.
#
#----------------------------------------------------------------------------------------------------------------------
#
#  20010620 BGH; created.
#  20010621 BGH; updated to use directory location in backup file name.
#  20010716 BGH; updated to support move directive.
#  20010717 BGH; changed to support specification of file not in local directory.
#  20061112 BGH; added proper-case trash can names.
#  20081228 BGH; modified to handle directory names with blank spaces in their names.
#  20180118 BGH; modified backup_to_garbage.bash to form a library version based on a common function.
#  20180303 BGH; added use of a YYYYMM subdirectory of the garbage directory.
#  20190929 BGH; moved to HLB repo.
#
#----------------------------------------------------------------------------------------------------------------------

declare -r __BashingLibraryDSpec=$(whereHolmespunLibraryBashing)/Library

source ${__BashingLibraryDSpec}/echoAndExecute.bash
source ${__BashingLibraryDSpec}/echoGarbageDSpec.bash
source ${__BashingLibraryDSpec}/echoLocalArchiveNameFor.bash

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__portToGarbage
###  @param	PortCommand		The Linux command that will be applied (i.e. cp or mv).
###  @param	ListOfSourceFSpec	A list of specifications of files to be acted upon.
###  @brief	Apply the given command to each file, and display the applied command to the user.
###  @remark	Uses the echoLocalArchiveNameFor utility to determine the name used in the garbage directory.
###
###  @details	The __portToGarbage function applies the PortCommand to a ListOfSourceFSpec.
###  		The PortCommand is likely a form of cp or mv command.
###  		Each file is moved into a garbage directory: The first of ${HMM_GARBAGE_DSPEC}, ${GARBAGE}, or
###  		${HOME}/Garbage to be non-null. An error is raised if this directory does not already exist.
###
###  		Within the garbage directory, a YYYYMM directory is created base on the current year and month.
###  		Files are created within that subdirectory using a name file name that is based on their original file
###  		name. Each is prefixed with a YYYYMMDD_HHMMSS date and time stamp that represents the current data and
###  		time; all files are given that same stamp.
###
#----------------------------------------------------------------------------------------------------------------------

function __portToGarbage() {
  #
  local -r    PortCommand=${1}
  shift 1
  local -r -a ListOfSourceFSpec=(${*})
  #
  local -r -i NumbOfSourceFSpec=${#ListOfSourceFSpec[*]}
  #
  [ ${NumbOfSourceFSpec} -eq 0 ] && return 1
  #
  local       GarbageDSpec=$(echoGarbageDSpec)
  #
  [ ${?} -ne 0 ] && return ${?}
  #
  local -r    DatStamp=$(date '+%Y%m%d_%H%M%S')
  #
  GarbageDSpec+="/${DatStamp:0:6}"
  #
  [ ! -d ${GarbageDSpec} ] && echoAndExecute "mkdir --parents ${GarbageDSpec}" 
  #
  local    SourceFSpec TargetFName
  #
  local -i IndxOfSourceFSpec=0
  #
  while [ ${IndxOfSourceFSpec} -lt ${NumbOfSourceFSpec} ]
  do
    #
    SourceFSpec=${ListOfSourceFSpec[${IndxOfSourceFSpec}]}
    #
    if [ -e ${SourceFSpec} ] || [ -L ${SourceFSpec} ]
    then
       #
       TargetFName=$(echoLocalArchiveNameFor ${SourceFSpec} ${DatStamp})
       #
       echoAndExecute "${PortCommand} ${SourceFSpec} ${GarbageDSpec}/${TargetFName}"
       #
       [ ${?} -ne 0 ] && return 2
       #
    fi
    #
    IndxOfSourceFSpec+=1
    #
  done
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	copyToGarbage
###  @param	ListOfSourceFSpec	A list of specifications of files to be copied.
###  @brief	Copies each file in a list of files into the garbage directory.
###  @remark	Uses the __portToGarbage function with a 'cp --recursive --preserve' command to do so.
###
#----------------------------------------------------------------------------------------------------------------------

function copyToGarbage() { __portToGarbage "cp --recursive --preserve" ${*}; }

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	moveToGarbage
###  @param	ListOfSourceFSpec	A list of specifications of files to be moved.
###  @brief	Moves each file in a list of files into the garbage directory.
###  @remark	Uses the __portToGarbage function with a 'mv' command to do so.
###
#----------------------------------------------------------------------------------------------------------------------

function moveToGarbage() { __portToGarbage "mv" ${*}; }

#----------------------------------------------------------------------------------------------------------------------
