#----------------------------------------------------------------------------------------------------------------------
###
###		Library/echoGarbageDSpec.bash
###
###  @file
###  @author	Brian G. Holmes
###  @copyright	GNU General Public License
###  @brief	Defines a simple but useful function for determining which directory the user would like to use as the
###		garbage directory.
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
#  20180501 BGH; separated from copyToGarbage_and_moveToGarbage.bash.
#  20190929 BGH; moved to HLB repo.
#
#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	echoGarbageDSpec
###  @brief	Determine which directory the user would like used as the garbage directory.
###
###  @details	The echoGarbageDSpec function determines the user's preference for a garbage directory by finding the
###		first of ${HOLMESPUN_GARBAGE_DSPEC}, ${GARBAGE}, or ${HOME}/Garbage that is not null. An error
###		condition is raised if that directory does not exist.
###
#----------------------------------------------------------------------------------------------------------------------

function echoGarbageDSpec() {
  #
  local GarbageDSpec
  #
  for GarbageDSpec in ${HOLMESPUN_GARBAGE_DSPEC:-} ${GARBAGE:-} ${HOME}/Garbage
  do
    #
    break
    #
  done
  #
  if [ ! -d ${GarbageDSpec} ]
  then
     #
     echo "ERROR: The ${GarbageDSpec} directory does not exist." 1>&2
     #
     return 1
     #
  fi
  #
  echo ${GarbageDSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------
#  (eof)
