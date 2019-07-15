#----------------------------------------------------------------------------------------------------------------------
###
###			Bash/Library/spit_spite_spitn_and_spew.bash
###
###	@file
###	@author		Brian G. Holmes
###	@copyright	GNU General Public License
###	@brief		Contains several simple but very useful text processing functions.
###
###	@remark		Specifying the target file first makes use of each of these functions cleaner, as they appear
###			more more object oriented, than the common commands that are used to implement them.
###
#----------------------------------------------------------------------------------------------------------------------
#
#  Bash/Library/spit_spite_spitn_and_spew.bash
#
#	spit  <fspec> <word>...			Uses echo command to append a line of words to the specified file.
#	spite <fspec> <word>...			Same as spit but with interpretation of escape sequences (e.g. \n).
#	spitn <fspec> <word>...			Same as spit but without adding an endline character to the output.
#
#	spew  <fspec-target> <fspec-source>...	Appends a set of specified source files to a specified target file.
#
#  Copyright 2004-2018 Brian G. Holmes
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
#  20180113 BGH; created based on ancient best practices.
#
#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	spew
###  @param	TargetFSpec		The target file specification.
###  @param	ListOfSourceFSpec	The source file specification.
###  @brief	Appends the contents of a set of source files to a specified target file.
###
#----------------------------------------------------------------------------------------------------------------------

function spew() {
  #
  local FSpec=${1}
  shift 1
  #
  cat "${*}" >> ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	spit
###  @param	TargetFSpec	The target file specification.
###  @param	ListOfWords	A list of words.
###  @brief	Appends a list of words as a new line to the end of a target file.
###
#----------------------------------------------------------------------------------------------------------------------

function spit() {
  #
  local FSpec=${1}
  shift 1
  #
  echo "${*}" >> ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	spite
###  @param	TargetFSpec	The target file specification.
###  @param	ListOfWords	A list of words.
###  @brief	Appends a list of words that may contain escape sequences as a new line to the end of a target file.
###
#----------------------------------------------------------------------------------------------------------------------

function spite() {
  #
  local -r FSpec="${1}"
  shift 1
  #
  echo -e "${*}" >> ${FSpec}
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	spitn
###  @param	TargetFSpec	The target file specification.
###  @param	ListOfWords	A list of words.
###  @brief	Appends a list of words (without adding a new line) to the end of a target file.
###
#----------------------------------------------------------------------------------------------------------------------

function spitn() {
  #
  local -r FSpec="${1}"
  shift 1
  #
  echo -n "${*}" >> ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------
