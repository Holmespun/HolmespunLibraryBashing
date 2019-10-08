#----------------------------------------------------------------------------------------------------------------------
###
###  Library/echoAndExecute.bash
###
###  @file
###  @author	Brian G. Holmes
###  @copyright	GNU General Public License
###  @brief	Defines a simple (but very useful) function for displaying commands before they are invoked.
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
###  @fn	echoAndExecute
###  @param	Command	A Linux command.
###  @brief	Displays and then executes the given command.
###
#----------------------------------------------------------------------------------------------------------------------

function echoAndExecute() {
  #
  local -r Command=${*}
  #
  echo "${Command}" | sed --expression="s,${HOME},\$HOME,g"
  #
  ${Command}
  #
}

#----------------------------------------------------------------------------------------------------------------------
