#----------------------------------------------------------------------------------------------------------------------
###
###		Bash/Library/echoInColor.bash
###
###  @file
###  @author	Brian G. Holmes
###  @copyright	GNU General Public License
###  @brief	Defines several functions that display highlighted and color text using an echo command.
###
#----------------------------------------------------------------------------------------------------------------------
#
#  Copyright 2018 Brian G. Holmes
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
#  20180311 BGH; created.
#  20180423 BGH; modified to use HMM_MONOCHROMATIC environment variable.
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
###  @remark	The Bash/Testing/echoEscapeSequencesForTextColorAndFormat.bash script was created to better understand
###		escape sequences that produce colored and otherwise modified text in a terminal window.
###
###  @details	The __echoInColor function surrounds the given Message in ColorCode escape sequences that allow the
###		text to be highlighted and colored. The ColorCode is itself wrapped in a '\e[' prefix and 'm' suffix,
###		so represents only the numeric code portion of the escape sequence. If the HMM_MONOCHROMATIC
###		environment variable is set then the ColorCode is not used.
###
#----------------------------------------------------------------------------------------------------------------------

function __echoInColor() {
  #
  local -r ColorCode="${1}"
  shift 1
  #
  if [ "${HMM_MONOCHROMATIC+IS_SET}" = "IS_SET" ]
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
###  @fn	echoInColorGreen
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in green.
###
###  @fn	echoInColorRed
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in red.
###
###  @fn	echoInColorRedBold
###  @param	Message	Text to be displayed.
###  @brief	Displays a textual message in bold red.
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

function echoInColorBlue()	{ __echoInColor "38;5;12"	"${*}"; }
function echoInColorGreen()	{ __echoInColor "38;5;10"	"${*}"; }
function echoInColorRed()	{ __echoInColor "38;5;9"	"${*}"; }
function echoInColorRedBold()	{ __echoInColor "38;5;9m\\e[1"	"${*}"; }
function echoInColorWhite()	{ __echoInColor "38;5;15"	"${*}"; }
function echoInColorWhiteBold()	{ __echoInColor "38;5;15m\\e[1"	"${*}"; }
function echoInColorYellow()	{ __echoInColor "38;5;11"	"${*}"; }

#----------------------------------------------------------------------------------------------------------------------
