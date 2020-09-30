#!/bin/bash
##----------------------------------------------------------------------------------------------------------------------
###
###		wordsNotKnown.bash
###
###  @file
###  @brief	Uses aspell to look for words it does not know in all files specified.
###  @author	Brian G. Holmes
###  @copyright	GNU General Public License
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
#  20180511 BGH; created from previous work.
#  20190929 BGH; moved to HLB repo.
#
#----------------------------------------------------------------------------------------------------------------------

source $(whereHolmespunLibraryBashing)/Library/echoInColor.bash

declare -r __SeparatorMajor="================"
declare -r __SeparatorMinor="----------------"

declare    __Separator=${__SeparatorMajor}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__wordsNotKnown
###  @param	ListOfFSpec	   A list of files to be searched for misspelled words.
###  @brief	Use the aspell command to display a list of words it does not know.
###
###  @details	The __wordsNotKnown function creates a command pipe that:
###		1. Dumps the contents of each file;
###		2. Separates camel-case tokens|words|identifiers into their lower- and proper-case parts;
###		3. Checks for words that aspell does not know;
###		4. Sorts those words and remove duplicates;
###		5. Removes words that made entirely of capital letters and numbers;
###		6. Removes words that the user does not want reported; from .wordsNotKnown.conf files.
###
#----------------------------------------------------------------------------------------------------------------------

function __wordsNotKnown() {
  #
  local -r ListOfFSpec=${*}
  #
  if [ ${#ListOfFSpec} -eq 0 ]
  then
     #
     echo "USAGE: wordsNotKnown.bash <file-specification>..."
     echo "USAGE: Check configuration for every directory <file-specification>;"
     echo "USAGE: List words not known to aspell or configured for every other file."
     #
     exit 1
     #
  fi
  #
  echo "wordsNotKnown..."
  #
  local    TargetFSpec TargetDSpec WordNotKnownItem
  #
  #  WordNotKnownBy[word]: The list of files that contain a word that is not known.
  #
  local -A WordNotKnownBy
  #
  #  CommandPrefix: Construct the first part of the spell-check command.
  #
  local    CommandPrefix=
  #
  #  Separate camel-case tokens|words|identifiers into their lower- and proper-case parts.
  #
  CommandPrefix+="sed --expression=\"s,\([a-z]\)\([A-Z]\),\1 \2,g\""
  #
  #  Check for words that aspell does not know.
  #
  CommandPrefix+=" | aspell --dont-backup --mode=none list"
  #
  #  Sort those words and remove duplicates.
  #
  CommandPrefix+=" | sort --unique"
  #
  #  Remove words that made entirely of capital letters and numbers.
  #
  CommandPrefix+=" | grep --invert-match \"^[A-Z0-9]\\\{,\\\}$\""
  #
  #  ListOfConfigFSpec: The configuration files to be applied to each file.
  #  GrepCompo: Remove words that the user does not want reported.
  #
  local    ListOfConfigFSpec=
  local    GrepCompo=
  #
  [ -s ${HOME}/.wordsNotKnown.conf ] && ListOfConfigFSpec+=" ${HOME}/.wordsNotKnown.conf"
  #
  [ "${HOME}" != "${PWD}" ] && [ -s ./.wordsNotKnown.conf ] && ListOfConfigFSpec+=" ./.wordsNotKnown.conf"
  #
  [ ${#ListOfConfigFSpec} -gt 0 ] && GrepCompo="| grep --word-regexp --invert-match ${ListOfConfigFSpec// / --file=}"
  #
  #  For every file specified...
  #
  local -i TargetCount=0
  #
  for TargetFSpec in ${ListOfFSpec}
  do
    #
    [ -d ${TargetFSpec} ] && continue
    #
    TargetCount+=1
    #
    TargetDSpec=$(dirname ${TargetFSpec})
    #
    #  For each word not known in the target file...
    #
    for WordNotKnownItem in $(cat ${TargetFSpec} | eval ${CommandPrefix} ${GrepCompo})
    do
      #
      if [ "${WordNotKnownBy[${WordNotKnownItem}]+IS_SET}" = IS_SET ]
      then
	 #
	 WordNotKnownBy[${WordNotKnownItem}]+=" ${TargetFSpec}"
	 #
      else
	 #
	 WordNotKnownBy[${WordNotKnownItem}]="${TargetFSpec}"
	 #
      fi
      #
    done
    #
  done
  #
  #  Report our findings...
  #
  local -r WordNotKnownList=$(for WordNotKnownItem in ${!WordNotKnownBy[*]}; do echo ${WordNotKnownItem}; done | sort)
  #
  WordNotKnownItem=
  #
  for WordNotKnownItem in ${WordNotKnownList}
  do
    #
    echo "${__Separator}"
    #
    echoInColorYellow "${WordNotKnownItem}..."
    #
    grep --color --with-filename "${WordNotKnownItem}" ${WordNotKnownBy[${WordNotKnownItem}]}
    #
    __Separator=${__SeparatorMinor}
    #
  done
  #
  #  Also let the user know if all words were known.
  #
  if [ ${#WordNotKnownItem} -eq 0 ] && [ ${TargetCount} -gt 0 ]
  then
     #
     echo "${__Separator}"
     #
     echo "All words are known."
     #
  fi
  #
  echo "${__SeparatorMajor}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

__wordsNotKnown ${*}

#----------------------------------------------------------------------------------------------------------------------
