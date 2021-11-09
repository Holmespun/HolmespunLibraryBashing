#----------------------------------------------------------------------------------------------------------------------
###
###		Library/echoInColor.bash
###
###  @file
###  @author	Brian G. Holmes
###  @copyright	GNU General Public License
###  @brief	Defines several functions that display highlighted and color text using an echo command.
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
#  20180311 BGH; created.
#  20180423 BGH; modified to use HOLMESPUN_MONOCHROMATIC environment variable.
#  20190929 BGH; moved to HLB repo.
#  20210508 BGH; support for mauve and teal.
#
#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__echoInColor
###  @param	ColorCode	A color and highlighting escape sequence.
###  @param	Message		The text to be displayed.
###  @brief	Displays a given message using the given color code.
###
###  @remark	See https://misc.flogisoft.com/bash/tip_colors_and_formatting
###
###  @remark	The Testing/echoEscapeSequencesForTextColorAndFormat.bash script was created to better understand
###		escape sequences that produce colored and otherwise modified text in a terminal window.
###
###  @details	The __echoInColor function surrounds the given Message in ColorCode escape sequences that allow the
###		text to be highlighted and colored. The ColorCode is itself wrapped in a '\e[' prefix and 'm' suffix,
###		so represents only the numeric code portion of the escape sequence. If the HOLMESPUN_MONOCHROMATIC
###		environment variable is set then the ColorCode is not used.
###
#----------------------------------------------------------------------------------------------------------------------

function echoInColorGivenWithEscapesDisabled() {
  #
  local -r ColorCode="${1}"
  shift 1
  #
  if [ "${HOLMESPUN_MONOCHROMATIC+IS_SET}" = "IS_SET" ]
  then
     #
     echo "${*}"
     #
  else
     #
     echo "\[\e[${ColorCode}m\]${*}\[\e[0m\]"
     #
  fi
  #
}

#----------------------------------------------------------------------------------------------------------------------

function echoInColorGivenWithEscapesEnabled() {
  #
  local -r ColorCode="${1}"
  shift 1
  #
  if [ "${HOLMESPUN_MONOCHROMATIC+IS_SET}" = "IS_SET" ]
  then
     #
     echo "${*}"
     #
  else
     #
     echo -e "\e[${ColorCode}m${*}\e[0m"
     #
  fi
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	echoInColorBlue
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in blue.
###
###  @fn	echoInColorBlueBold
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in bold blue.
###
###  @fn	echoInColorGreen
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in green.
###
###  @fn	echoInColorMauve
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in mauve (pale purple).
###
###  @fn	echoInColorMauveBold
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in bold mauve (pale purple).
###
###  @fn	echoInColorRed
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in red.
###
###  @fn	echoInColorRedBold
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in bold red.
###
###  @fn	echoInColorTeal
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in teal (dark greenish-blue).
###
###  @fn	echoInColorTealBold
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in bold teal (dark greenish-blue).
###
###  @fn	echoInColorWhite
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in white.
###
###  @fn	echoInColorWhiteBold
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in bold white.
###
###  @fn	echoInColorYellow
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in yellow.
###
#----------------------------------------------------------------------------------------------------------------------

function echoInColorBlue()		{ echoInColorGivenWithEscapesEnabled "38;5;12"		"${*}"; }
function echoInColorBlueBold()		{ echoInColorGivenWithEscapesEnabled "38;5;12m\\e[1"	"${*}"; }
function echoInColorGreen()		{ echoInColorGivenWithEscapesEnabled "38;5;10"		"${*}"; }
function echoInColorGreenBold()		{ echoInColorGivenWithEscapesEnabled "38;5;10m\\e[1"	"${*}"; }
function echoInColorMauve()		{ echoInColorGivenWithEscapesEnabled "38;5;13"		"${*}"; }
function echoInColorMauveBold()		{ echoInColorGivenWithEscapesEnabled "38;5;13m\\e[1"	"${*}"; }
function echoInColorRed()		{ echoInColorGivenWithEscapesEnabled "38;5;9"		"${*}"; }
function echoInColorRedBold()		{ echoInColorGivenWithEscapesEnabled "38;5;9m\\e[1"	"${*}"; }
function echoInColorTeal()		{ echoInColorGivenWithEscapesEnabled "38;5;14"		"${*}"; }
function echoInColorTealBold()		{ echoInColorGivenWithEscapesEnabled "38;5;14m\\e[1"	"${*}"; }
function echoInColorWhite()		{ echoInColorGivenWithEscapesEnabled "38;5;15"		"${*}"; }
function echoInColorWhiteBold()		{ echoInColorGivenWithEscapesEnabled "38;5;15m\\e[1"	"${*}"; }
function echoInColorYellow()		{ echoInColorGivenWithEscapesEnabled "38;5;11"		"${*}"; }
function echoInColorYellowBold()	{ echoInColorGivenWithEscapesEnabled "38;5;11"		"${*}"; }

function echoInColorOrange()   		{ echoInColorGivenWithEscapesEnabled "0;38;5;208"	"${*}"; }
function echoInColorOrangeBold()	{ echoInColorGivenWithEscapesEnabled "0;38;5;208m\\e[1"	"${*}"; }

#----------------------------------------------------------------------------------------------------------------------
