#----------------------------------------------------------------------------------------------------------------------
###
###		Bash/Library/echoDatStampedFSpec.bash
###
###  @file
###  @author	Brian G. Holmes
###  @copyright	GNU General Public License
###  @brief	Defines a function for naming unique files with date and time stamps.
###
#----------------------------------------------------------------------------------------------------------------------
#
#  Copyright 2018 Brian G. Holmes
#
#	This program is free software: you can redistribute it and/or modify it under the terms of the GNU General
#	Public License as published by the Free Software Foundation, either version 3 of the License, or (at your
#	option) any later version.
#
#	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
#	implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#	for more details.
#
#	You should have received a copy of the GNU General Public License along with this program.  If not, see
#	<https://www.gnu.org/licenses/>.
#
#  See the COPYING.text file for further information.
#
#  20180308 BGH; created.
#
#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	echoDatStampedFSpec
###  @param	Prefix	A file specification prefix.
###  @brief	Generates a unique file specification that includes a date and time stamp.
###
###  @details	Append a Date And Time Stamp to a given Prefix to form a file specification, check to see that the
###		file does not exist, and if it does then increase the time portion of it name until a specification is
###		achieved that does not exist. Existence checking is only performed if the directory path of the
###		Prefix exists.
###
#----------------------------------------------------------------------------------------------------------------------

function echoDatStampedFSpec() {
  #
  local -r    Prefix="${*}"
  #
  local -r    DatePart=$(date '+%Y%m%d')
  local -r    TimePart=$(date '+%H%M%S')
  #
  local -r    FormatFSpec="${Prefix}${DatePart}_%06d"
  #
  local    -i TimeNumber=$(echo ${TimePart} | sed --expression='s,^0[0]*,,')
  #
  local       ResultFSpec=$(printf "${FormatFSpec}" ${TimeNumber})
  #
  local -r    PrefixDSpec=$(dirname ${Prefix})
  #
  if [ -d ${PrefixDSpec} ]
  then
     #
     while [ -e ${ResultFSpec} ]
     do
       #
       TimeNumber+=1
       #
       ResultFSpec=$(printf "${FormatFSpec}" ${TimeNumber})
       #
     done
     #
  fi
  #
  echo "${ResultFSpec}"
  #
}

#----------------------------------------------------------------------------------------------------------------------
