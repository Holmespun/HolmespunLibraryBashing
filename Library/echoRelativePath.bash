#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
###
###	echoRelativePath.bash...
###
###	@file
###	@author		Brian G. Holmes
###	@copyright	GNU General Public License
###	@brief		Holmespun Testing Manager (HTM) script.
###	@todo		https://github.com/Holmespun/HolmespunMakefileMethod/issues
###	@remark		dirnameRelative.bash [<from-file-specification>] [<to-file-specification>]"
###
###	@details	The echoRelativePath function within this file displays the relative directory that represents
###			the path between <from-file-specification> and <to-file-specification>; the specifications are
###			assumed to be comparible (e.g. both relative or both absolute). Current directory names are
###			ignored (i.e ".").  Undone directory names are also ignored (e.g. "name/..").
###
###			Example: echoRelativePath ./Working ../../Testing/data.text
###
###			Result:  ../../../Testing/data.text
###
#----------------------------------------------------------------------------------------------------------------------
#
#  20190713 BGH; created.
#
#  Copyright (c) 2019 Brian G. Holmes
#
#	This program is part of the Holmespun Makefile Method.
#
#	The Holmespun Makefile Method is free software: you can redistribute it and/or modify it under the terms of the
#	GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	The Holmespun Makefile Method is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
#	without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#	Public License for more details.
#
#	You should have received a copy of the GNU General Public License along with this program. If not, see
#	<https://www.gnu.org/licenses/>.
#
#  See the COPYING.text file for further information.
#
#----------------------------------------------------------------------------------------------------------------------

set -u

#----------------------------------------------------------------------------------------------------------------------

function echoCleanDirectoryNameList() {
  #
  local -r GivenDSpec=${1}
  #
  local -a NameList
  #
  local -i NameIndex=0
  #
  local -i BackIndex=0
  #
  local    PartText
  #
  for PartText in ${GivenDSpec//\// }
  do
    #
    if [ ${#PartText} -gt 0 ] && [ "${PartText}" != "." ]
    then
       #
       if [ "${PartText}" = ".." ]
       then
          #
          if [ ${NameIndex} -gt 0 ]
	  then
             #
	     NameIndex=$((${NameIndex} - 1))
             #
          else
             #
             BackIndex+=1
             #
          fi
          #
       else
          #
          NameList[${NameIndex}]="${PartText}"
          #
          NameIndex+=1
          #
       fi
       #
    fi
    #
  done
  #
  local -r -i BackCount=${BackIndex}
  local -r -i NameCount=${NameIndex}
  #
  BackIndex=0
  NameIndex=0
  #
  while [ ${BackIndex} -lt ${BackCount} ]
  do
    #
    echo ".."
    #
    BackIndex+=1
    #
  done
  #
  while [ ${NameIndex} -lt ${NameCount} ]
  do
    #
    echo "${NameList[${NameIndex}]}"
    #
    NameIndex+=1
    #
  done
  #
}

#----------------------------------------------------------------------------------------------------------------------

function echoRelativePath() {
  #
  local -r -a SourcePartList=($(echoCleanDirectoryNameList ${1-}))
  local -r -a TargetPartList=($(echoCleanDirectoryNameList ${2-}))
  #
  local -r -i SourcePartCount=${#SourcePartList[*]}
  local -r -i TargetPartCount=${#TargetPartList[*]}
  #
  local    -i Index=0
  #
  while [ ${Index} -lt ${SourcePartCount} ] && [ ${Index} -lt ${TargetPartCount} ]
  do
    #
    [ "${SourcePartList[${Index}]}" != "${TargetPartList[${Index}]}" ] && break
    #
    Index+=1
    #
  done
  #
  local       Result=
  #
  local    -i SourcePartIndex=${Index}
  #
  while [ ${SourcePartIndex} -lt ${SourcePartCount} ]
  do
    #
    if [ "${SourcePartList[${SourcePartIndex}]}" = ".." ]
    then
       #
       Result+="/*"	# We do not know what it is.
       #
    else
       #
#      Result+="/${SourcePartList[${SourcePartIndex}]}"
       Result+="/.."
       #
    fi
    #
    SourcePartIndex+=1
    #
  done
  #
  local    -i TargetPartIndex=${Index}
  #
  while [ ${TargetPartIndex} -lt ${TargetPartCount} ]
  do
    #
    Result+="/${TargetPartList[${TargetPartIndex}]}"
    #
    TargetPartIndex+=1
    #
  done
  #
  [ ${#Result} -eq 0 ] && Result="/."
  #
  printf "${Result:1}\n"
  #
}

#----------------------------------------------------------------------------------------------------------------------
