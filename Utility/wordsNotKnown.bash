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
#  Copyright (c) 2018-2022 Brian G. Holmes
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

declare -r __WhereHolmespunLibraryBashing=$(whereHolmespunLibraryBashing)

source ${__WhereHolmespunLibraryBashing}/Library/echoInColor.bash
source ${__WhereHolmespunLibraryBashing}/Library/echoListOfConfigurationFSpec.bash

#----------------------------------------------------------------------------------------------------------------------

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

function __echoWordsNotKnownUsage() {
  #
  echo "USAGE: wordsNotKnown.bash <file-specification> [ <file-specification> ]..."
  echo
  echo "Describe all of the words in the specified files that are not known."
  echo
  echo "Users can define .wordsNotKnown.conf configuration files that point to 'known' words files."
  echo "Every configuration file in directories from / to \${PWD} will be used."
  echo "Whole words that are found in a 'known' words file will not be reported as not known."
  echo "Every 'known' word must appear on a line of its own in a 'known' words file."
  echo
  echo "A set of predefined 'known' words files are collocated with the wordsNotKnown.bash script."
  echo "For example, wordsNotKnownBefore.bash.text and .wordsNotKnownBefore.c++.text."
  echo "Any file listed in the configuration file that cannot be found will be to see if it is predefined."
  echo
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoListOfConfiguredDataFSpec() {
  #
  local	-r ConfigFName=${1}
  #
  local    ConfigFSpec ConfigDataLine
  #
  local    PossibleDataFName
  local    PossibleDataFSpec
  #
  local    ItemOfDataFSpec PossibleDataFSpec
  #
  #  Returns a list that has no predictable order.
  #
  local -A ListOfDataFSpec
  #
  for ConfigFSpec in $(echoListOfConfigurationFSpec ${ConfigFName})
  do
    #
    while read ConfigDataLine
    do
      #
      [ ${#ConfigDataLine} -eq 0 ] && continue
      #
      [ "${ConfigDataLine:0:1}" = "#" ] && continue
      #
      ItemOfDataFSpec=$(eval echo ${ConfigDataLine})
      #
      if [ -f ${ItemOfDataFSpec} ]
      then
         #
         ListOfDataFSpec["${ItemOfDataFSpec}"]="Use"
         #
      else
         #
         echoInColorRed    "ERROR: Invalid 'known' words file specification configured."	>&2
         echoInColorYellow "INFO:  While processing the '${ConfigFSpec}' file..."		>&2
         echoInColorYellow "INFO:  The file named '${ConfigDataLine}' could not be resolved."	>&2
         #
         return 1
         #
      fi
      #
    done < ${ConfigFSpec}
    #
  done
  #
  echo ${!ListOfDataFSpec[*]}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __wordsNotKnown() {
  #
  local -r ListOfFSpec=${*}
  #
  if [ ${#ListOfFSpec} -eq 0 ]
  then
     #
     __echoWordsNotKnownUsage >&2
     #
     return 1
     #
  fi
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
  #  ListOfKnownWordsFSpec: The configuration files to be applied to each file.
  #
  local    ItemOfKnownWordsFSpec
  #
  local    ListOfKnownWordsFSpec=$(__echoListOfConfiguredDataFSpec .wordsNotKnown.conf)
  #
  [ ${#ListOfKnownWordsFSpec} -eq 0 ] && return 1
  #
  #  GrepCompo: Remove words that the user does not want reported.
  #
  local    GrepCompo=
  #
  GrepCompo="| grep --line-regexp --invert-match"
  #
  for ItemOfKnownWordsFSpec in ${ListOfKnownWordsFSpec}
  do
    #
    GrepCompo+=" --file=${ItemOfKnownWordsFSpec}"
    #
  done
  #
  #  For every file specified...
  #
  for TargetFSpec in ${ListOfFSpec}
  do
    #
    [ -d ${TargetFSpec} ] && continue
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
  local -i ResultStatus=0
  #
  local -r WordNotKnownList=$(for WordNotKnownItem in ${!WordNotKnownBy[*]}; do echo ${WordNotKnownItem}; done | sort)
  #
  if [ ${#WordNotKnownList} -gt 0 ]
  then
     #
     echo "wordsNotKnown..."
     #
     local -i NotKnownCount=0
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
       NotKnownCount+=1
       #
     done
     #
     echo "${__Separator}"
     #
     echo "Found ${NotKnownCount} words not known: $(echo ${WordNotKnownList} | tr '\n' ' ')"
     #
     echo "${__SeparatorMajor}"
     #
     ResultStatus=1
     #
  fi
  #
  return ${ResultStatus}
  #
}

#----------------------------------------------------------------------------------------------------------------------

__wordsNotKnown ${*}

#----------------------------------------------------------------------------------------------------------------------
