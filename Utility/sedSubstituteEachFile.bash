#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
###
###			sedSubstituteEachFile.bash
###
###	@file
###	@author		Brian G. Holmes
###	@copyright	GNU General Public License
###	@brief		Modifies the name and content of files by substituting regular expression with its replacement.
###	@remark		Usage: sedSubstituteEachFile.bash <regex> <replacement> <file-specification>...
###
###	@details	The script replaces a Rexpression target with a Replacement string in each file in a
###			ListOfFSpec, and changes the name of those files based on the same target and replacement. The
###			source files are modified and renamed, as applicable. The script displays the specification of
###			each file with a parenthetical expression that describes how it was changed if it was changed:
###			The work "changed" is used to indicate that the content was modified; the word "renamed" is
###			used to indicate that the file was renamed.
###
###	TODO		Preserve the permissions associated with each modified file.
###
#----------------------------------------------------------------------------------------------------------------------
#
#  Copyright (c) 2006-2019 Brian G. Holmes
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
#  20061112 BGH; formalized a very old SH script.
#  20180303 BGH; renamed from sed_substitute_each_file.bash, added to HMM repo, added checking for file existence.
#  20190929 BGH; moved to HLB repo.
#
#----------------------------------------------------------------------------------------------------------------------

set -u

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__sedSubstituteEachFile
###  @param	Rexpression	A regular expression.
###  @param	Replacement	A replacement string.
###  @param	ListOfFSpec	A list of file specifications.
###  @brief	Modifies the name and content of files by substituting regular expression with its replacement.
###
###  @details	A quote from the sed manual pages: "s/regexp/replacement/ Attempt to match regexp against the pattern
###		space.  If successful, replace that portion matched  with replacement.   The replacement may contain
###		the special character & to refer to that portion of the pat‐ tern space which matched, and the special
###		escapes \1 through \9 to refer to the corresponding matching sub-expressions in the regexp."
###
#----------------------------------------------------------------------------------------------------------------------

function __sedSubstituteEachFile() {
  #
  local -r Rexpression="${1-}"
  local -r Replacement="${2-}"
  shift 2
  local -r ListOfFSpec="${*}"
  #
  local -r ScriptFName=$(basename ${0})
  #
  if [ ${#ListOfFSpec} -eq 0 ]
  then
     #
     echo "USAGE: ${ScriptFName} <target> <replacement> <fspec>..."
     #
     exit 1
     #
  fi
  #
  local -A ListOfTargetFSpec
  #
  local    TargetFSpec ResultFSpec Status
  #
  for TargetFSpec in ${ListOfFSpec}
  do
    #
    if [ ! -e ${TargetFSpec} ]
    then
       #
       echo "ERROR: The '${TargetFSpec}' file does not exist."
       #
       exit 1
       #
    fi
    #
    ListOfTargetFSpec["${TargetFSpec}"]=1
    #
  done
  #
  for TargetFSpec in ${!ListOfTargetFSpec[*]}
  do
    #
    ResultFSpec=`echo ${TargetFSpec} | sed s,${Rexpression},${Replacement},g`
    #
    sed -e "s,${Rexpression},${Replacement},g" ${TargetFSpec} > ${TargetFSpec}.${ScriptFName}.$$
    #
    diff ${TargetFSpec} ${TargetFSpec}.${ScriptFName}.$$ > /dev/null
    #
    Status=${?}
    #
    if [ ${Status} -eq 0 ]
    then
       #
       rm ${TargetFSpec}.${ScriptFName}.$$
       #
       if [ "${TargetFSpec}" = "${ResultFSpec}" ]
       then
          #
          echo "${TargetFSpec}"
          #
       else
          #
          echo "${TargetFSpec} (renamed)"
          #
  	mv ${TargetFSpec} ${ResultFSpec}
          #
       fi
       #
    else
       #
       mv ${TargetFSpec}.${ScriptFName}.$$ ${TargetFSpec}
       #
       if [ "${TargetFSpec}" = "${ResultFSpec}" ]
       then
          #
          echo "${TargetFSpec} (changed)"
          #
       else
          #
          echo "${TargetFSpec} (changed,renamed)"
          #
  	mv ${TargetFSpec} ${ResultFSpec}
          #
       fi
       #
    fi
    #
  done
  #
}

#----------------------------------------------------------------------------------------------------------------------

__sedSubstituteEachFile ${*}

#----------------------------------------------------------------------------------------------------------------------
