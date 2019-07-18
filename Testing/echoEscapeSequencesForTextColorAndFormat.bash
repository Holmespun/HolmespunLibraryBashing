#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
###
###	Bash/echoEscapeSequencesForTextColorAndFormat.bash
###
###	@file
###	@author		Brian G. Holmes
###	@copyright	GNU General Public License
###	@brief		Displays the effect of all of the color coding escape sequences.
###
###	@details	Some functions in this script are based on the colors_and_formatting.sh and 256-colors.sh
###			scripts posted on https://misc.flogisoft.com/bash/tip_colors_and_formatting/. Those scripts
###			come with the following copyright: "This program is free software. It comes without any
###			warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it
###			under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by
###			Sam Hocevar. See http://sam.zoy.org/wtfpl/COPYING for more details."
###
###			Some functions in this script are based on the information posted on
###			https://gist.github.com/XVilka/8346728, specifically those that deal with RGB color
###			specification.
###
###			You can cut one or more columns of the output tables from the resulting output by piping the
###			output through commands such as:
###	@code
###			sed --expression='s,+,|,g' | cut --delimiter=\| --fields=3  | more
###	@endcode
###			The 'more' command shows the escape sequences applied, but the 'less' does not.
###
###			To apply any given code, use the printf command or the echo -e command:
###	@code
###			echo -e "\e[3;104;34mItalic Navy Blue on Sky Blue		\e[0m"
###			printf "\e[1;38;5;11mBold Yellow\n				\e[0m"
###			echo -e "\e[1;48;2;0;0;100;38;2;192;96;0mBold Orange on Blue	\e[0m"
###	@endcode
###
###	@remark		See https://misc.flogisoft.com/bash/tip_colors_and_formatting. Be sure to note the Jan
###			Dolinár, 2017/09/27 12:58 Minor correction.
###
###	@remark		See "XTerm Control Sequences" at http://invisible-island.net/xterm/ctlseqs/ctlseqs.html
###
###	@remark		See https://gist.github.com/XVilka/8346728
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
#  20180425 BGH; created.
#
#----------------------------------------------------------------------------------------------------------------------

set -u

#----------------------------------------------------------------------------------------------------------------------

function __echoTableSeparator() {
  #
  local -r -i ColumnWidth=${1}
  local -r    ColumnCount=${2}
  local -r    RepeatValue="${3}"
  #
  local -r    OneColumnSeparator=$(printf "${RepeatValue}%.0s" $(seq 1 ${ColumnWidth}))
  #
  local -r    MultiColumnSeparator=$(printf "${OneColumnSeparator}+%.0s" $(seq 1 ${ColumnCount}))
  #
  echo "+${MultiColumnSeparator}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoEscapeSequenceCellValue_CP16() {
  #
  local -i -r ValueWidth=${1}
  local -i -r AttributeCode=${2}
  local -i -r BackColorCode=${3}
  local -i -r ForeColorCode=${4}
  #
  local    -r EscapeSequence="\e[${AttributeCode};${BackColorCode};${ForeColorCode}m"
  #
  printf "|${EscapeSequence} %-${ValueWidth}s \e[0m" "${EscapeSequence}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoEscapeSequenceCellValue_CP256_One() {
  #
  local -i -r ValueWidth=${1}
  local -i -r AttributeCode=${2}
  local -i -r GroundingCode=${3}	#  BG=48 FG=38
  local -i -r LoneColorCode=${4}
  #
  local    -r EscapeSequence="\e[${AttributeCode};${GroundingCode};5;${LoneColorCode}m"
  #
  printf "|${EscapeSequence} %-${ValueWidth}s \e[0m" "${EscapeSequence}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoEscapeSequenceCellValue_CP256_Two() {
  #
  local -i -r ValueWidth=${1}
  local -i -r AttributeCode=${2}
  local -i -r BackColorCode=${3}
  local -i -r ForeColorCode=${4}
  #
  local    -r EscapeSequence="\e[${AttributeCode};48;5;${BackColorCode};38;5;${ForeColorCode}m"
  #
  printf "|${EscapeSequence} %-${ValueWidth}s \e[0m" "${EscapeSequence}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoEscapeSequenceCellValue_TRUE() {
  #
  local -i -r ValueWidth=${1}
  local -i -r AttributeCode=${2}
  local    -r BackColorCode=${3}
  local    -r ForeColorCode=${4}
  #
  local    -r EscapeSequence="\e[${AttributeCode};48;2;${BackColorCode};38;2;${ForeColorCode}m"
  #
  printf "|${EscapeSequence} %-${ValueWidth}s \e[0m" "${EscapeSequence}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoEscapeSequencesFor_CP16ALL() {
  #
  local -a -r BackColorCodeList=({40..47} 49 {100..107})
  local -a -r ForeColorCodeList=({30..37} 39 {90..97})
  #
  local -i    BackColorCodeValu
  local -i    ForeColorCodeValu
  #
  local -a -r AttributeCodeList=({0..5} 7)
  #
  local -i    AttributeCodeValu
  #
  local -i -r ValueWidth=12
  #
  local    -r AttributeCodeHead="$(printf "| %-${ValueWidth}s " Normal Bold Dim Italic Underlined Blink Reverse)|"
  #
  local       EscapeSequence
  #
  local    -r OuterSeparator=$(__echoTableSeparator $((1+${ValueWidth}+1)) ${#AttributeCodeList[@]} "=")
  #
  local    -r InnerSeparator=$(echo ${OuterSeparator} | tr '=' '-')
  #
  local       Separator="${OuterSeparator}"
  #
  echo "CP16ALL: Echo Escape Sequences for Color Palette 16 (Attribute;Background;Foreground)..."
  #
  for BackColorCodeValu in ${BackColorCodeList[@]}
  do
    #
    echo "${Separator}"
    echo "${AttributeCodeHead}"
    #
    Separator="${InnerSeparator}"
    #
    echo "${Separator}"
    #
    for ForeColorCodeValu in ${ForeColorCodeList[@]}
    do
      #
      for AttributeCodeValu in ${AttributeCodeList[@]}
      do
        #
        __echoEscapeSequenceCellValue_CP16 ${ValueWidth} ${AttributeCodeValu} ${BackColorCodeValu} ${ForeColorCodeValu}
	#
      done
      #
      echo "|"
      #
    done
    #
  done
  #
  echo "${OuterSeparator}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoEscapeSequencesFor_CP256_Grounded() {
  #
  local -r -i GroundingCode=${1}
  local -r    GroundingName="${2}"
  local -r    GroundingText="${3}"
  #
  local -a -r ColorCodeList=({0..255})
  #
  local -i    ColorCodeValu
  #
  local -a -r AttributeCodeList=({0..5} 7)
  #
  local -i    AttributeCodeValu
  #
  local -i -r ValueWidth=14
  #
  local    -r AttributeCodeHead="$(printf "| %-${ValueWidth}s " Normal Bold Dim Italic Underlined Blink Reverse)|"
  #
  local       EscapeSequence
  #
  local    -r OuterSeparator=$(__echoTableSeparator $((1+${ValueWidth}+1)) ${#AttributeCodeList[@]} "=")
  #
  local    -r InnerSeparator=$(echo ${OuterSeparator} | tr '=' '-')
  #
  local       Separator="${OuterSeparator}"
  #
  echo "CP256${GroundingName}: Echo Escape Sequences for Color Palette 256"	\
			      "(Attribute;${GroundingCode};5;${GroundingText})..."
  #
  for ColorCodeValu in ${ColorCodeList[@]}
  do
    #
    if [ $((${ColorCodeValu} % 16)) -eq 0 ]
    then
       #
       echo "${Separator}"
       echo "${AttributeCodeHead}"
       #
       Separator="${InnerSeparator}"
       #
       echo "${Separator}"
       #
    fi
    #
    for AttributeCodeValu in ${AttributeCodeList[@]}
    do
      #
      __echoEscapeSequenceCellValue_CP256_One ${ValueWidth} ${AttributeCodeValu} ${GroundingCode} ${ColorCodeValu}
      #
    done
    #
    echo "|"
    #
  done
  #
  echo "${OuterSeparator}"
  #
}
#----------------------------------------------------------------------------------------------------------------------

function __echoEscapeSequencesFor_CP256BG() { __echoEscapeSequencesFor_CP256_Grounded 48 "BG" "Background"; }
function __echoEscapeSequencesFor_CP256FG() { __echoEscapeSequencesFor_CP256_Grounded 38 "FG" "Foreground"; }

#----------------------------------------------------------------------------------------------------------------------

function __echoEscapeSequencesFor_CP256ALL() {
  #
  local -a -r ColorCodeList=({0..255})
  #
  local -a -r AttributeCodeList=({0..5} 7)
  #
  local -i    AttributeValu
  #
  local -i -r ValueWidth=23
  #
  local    -r AttributeCodeHead="$(printf "| %-${ValueWidth}s " Normal Bold Dim Italic Underlined Blink Reverse)|"
  #
  local       EscapeSequence
  #
  local    -r OuterSeparator=$(__echoTableSeparator $((1+${ValueWidth}+1)) ${#AttributeCodeList[@]} "=")
  #
  local    -r InnerSeparator=$(echo ${OuterSeparator} | tr '=' '-')
  #
  local       Separator="${OuterSeparator}"
  #
  echo "CP256ALL: Echo Escape Sequences for Color Palette 256 (Attribute;48;5;Background;38;5;Foreground)..."
  #
  for BackgroundColor in ${ColorCodeList[@]}
  do
    #
    for ForegroundColor in ${ColorCodeList[@]}
    do
      #
      if [ $((${ForegroundColor} % 16)) -eq 0 ]
      then
         #
         echo "${Separator}"
         echo "${AttributeCodeHead}"
         #
         Separator="${InnerSeparator}"
         #
         echo "${Separator}"
         #
      fi
      #
      for AttributeValu in ${AttributeCodeList[@]}
      do
        #
        __echoEscapeSequenceCellValue_CP256_Two ${ValueWidth} ${AttributeValu} ${BackgroundColor} ${ForegroundColor}
        #
      done
      #
      echo "|"
      #
    done
    #
  done
  #
  echo "${OuterSeparator}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoEscapeSequencesFor_TRUE() {
  #
  local -i -r Period=${1}
  #
  local -a -r ColorPartList=(0 $(seq ${Period} ${Period} 254) 255)
  #
  local -a    ColorCode
  #
  local -i    Index=0
  #
  local -i    Red Green Blue
  #
  for Red in ${ColorPartList[@]}
  do
    #
    for Green in ${ColorPartList[@]}
    do
      #
      for Blue in ${ColorPartList[@]}
      do
        #
        ColorCode[${Index}]="${Red};${Green};${Blue}"
        #
        Index+=1
        #
      done
      #
    done
    #
  done
  #
  local -a -r AttributeCodeList=({0..5} 7)
  #
  local -i    AttributeCodeValu
  #
  local -i -r ValueWidth=39
  #
  local    -r AttributeCodeHead="$(printf "| %-${ValueWidth}s " Normal Bold Dim Italic Underlined Blink Reverse)|"
  #
  local       EscapeSequence
  #
  local    -r OuterSeparator=$(__echoTableSeparator $((1+${ValueWidth}+1)) ${#AttributeCodeList[@]} "=")
  #
  local    -r InnerSeparator=$(echo ${OuterSeparator} | tr '=' '-')
  #
  local       Separator="${OuterSeparator}"
  #
  echo "TRUE: Echo Escape Sequences for 24-bit RGB True Color with period ${Period}"	\
	     "(Attribute;38;2;BGR;BGG;BGB;48;2;FGR;FGG;FGB)..."
  #
  for BGIndex in $(seq 0 $((${Index}-1)))
  do
    #
    for FGIndex in $(seq 0 $((${Index}-1)))
    do
      #
      if [ $((${FGIndex} % ${#ColorPartList[@]})) -eq 0 ]
      then
         #
         echo "${Separator}"
         echo "${AttributeCodeHead}"
         #
         Separator="${InnerSeparator}"
         #
         echo "${Separator}"
         #
      fi
      #
      for AttributeValu in ${AttributeCodeList[@]}
      do
        #
        __echoEscapeSequenceCellValue_TRUE ${ValueWidth} ${AttributeValu}	\
					   ${ColorCode[${BGIndex}]} ${ColorCode[${FGIndex}]}
        #
      done
      #
      echo "|"
      #
    done
    #
  done
  #
  echo "${OuterSeparator}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoUsage() {
  #
  echo "USAGE: $(basename ${0}) <request>"
  echo "USAGE: Where the <request> may be one of..."
  echo "USAGE:       CP16ALL       - Color Palette  16 complete     (   342 lines)"
  echo "USAGE:       CP256ALL      - Color Palette 256 complete     ( 77826 lines)"
  echo "USAGE:       CP256BG       - Color Palette 256 backgrounds  (   306 lines)"
  echo "USAGE:       CP256FG       - Color Palette 256 foregrounds  (   306 lines)"
  echo "USAGE:       TRUE 32	   - 24-bit RGB True Color step 32  (708590 lines)"
  echo "USAGE:       TRUE 64	   - 24-bit RGB True Color step 64  ( 25002 lines)"
  echo "USAGE:       TRUE 128	   - 24-bit RGB True Color step 128 (  1460 lines)"
  echo "USAGE:       TRUE <period> - 24-bit RGB True Color"
  echo "USAGE:            Where <period> defines how many of the 256-value R, G, and B parts should be skipped,"
  echo "USAGE:            The default period of 64 shows five parts (0, 64, 128, 192, and 255) for each R, G, and B."
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __main() {
  #
  local    -r Request=${1-USAGE}
  local -i -r Period=${2-64}
  #
  case "${Request}" in
    ##
    CP16ALL)	__echoEscapeSequencesFor_CP16ALL
    ;;
    CP256ALL)	__echoEscapeSequencesFor_CP256ALL
    ;;
    CP256BG)	__echoEscapeSequencesFor_CP256BG
    ;;
    CP256FG)	__echoEscapeSequencesFor_CP256FG
    ;;
    TRUE)	__echoEscapeSequencesFor_TRUE ${Period}
    ;;
    *)		__echoUsage
    ;;
  esac
  #
}

#----------------------------------------------------------------------------------------------------------------------

__main ${*}

#----------------------------------------------------------------------------------------------------------------------
