#----------------------------------------------------------------------------------------------------------------------
###
###			Library/echoLocalArchiveNameFor.bash
###
###	@file
###	@author		Brian G. Holmes
###	@copyright	GNU General Public License
###	@brief		Contains a function that constructs a date and time stamped file name.
###
#----------------------------------------------------------------------------------------------------------------------
#
#  Copyright (c) 2018-2019 Brian G. Holmes
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
#  20180120 BGH; created.
#  20190929 BGH; moved to HLB repo.
#
#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	echoLocalArchiveNameFor
###  @param	SourceFSpec	The name of the file to be archived.
###  @param	DateAndTime	[optional] A date and time stamp to use in the archive name.
###  @brief	Displays a date and time stamped archive name for the given specification.
###
###  @details	The echoLocalArchiveNameFor function constructs and displays an archive name based on the SourceFSpec
###		it is given  The function may also be given a DateAndTime stamp; otherwise it generates one of its own
###		based on the current date and time. Each resulting name has three parts: the stamp, the absolute path
###		of the file specified by SourceFSpec, and the name part of the SourceFSpec. Any text to the left of and
###		including the $USER name is removed from the absolute path part. The three parts are concatenated using
###		slash characters, and then the entire string is modified in two ways: All space characters are changed
###		to underscore characters; All groups of slashes are changed to periods.
###
###		Example: Given SourceFSpec of Library/echoLocalArchiveNameFor.bash and a DateAndTime of
###		20180426_145100, when run from the BashWork folder in your $HOME directory, the function would display
###		20180426_145100.BashWork.Library.echoLocalArchiveNameFor.bash.
###
#----------------------------------------------------------------------------------------------------------------------

function echoLocalArchiveNameFor() {
  #
  local -r SourceFSpec="${1}"
  local -r DateAndTime="${2-$(date '+%Y%m%d_%H%M%S')}"
  #
  local -r SourceDSpec=$(dirname  ${SourceFSpec})
  local -r SourceFName=$(basename ${SourceFSpec})
  #
  local -r WhereWeWere=${PWD}
  #
  local    TargetFName=.${DateAndTime}/${PWD#*${USER}}/${SourceFSpec}
  #
  if [ -e ${SourceFSpec} ]
  then
     #
     cd ${SourceDSpec}
        #
        TargetFName=${DateAndTime}/${PWD#*${USER}}/${SourceFName}
        #
     cd ${WhereWeWere}
     #
  fi
  #
  local -r ResultFSpec=$(echo ${TargetFName} | sed --expression='s, ,_,g' --expression='s,/[/]*,.,g')
  #
  echo "${ResultFSpec}"
  #
}

#----------------------------------------------------------------------------------------------------------------------
