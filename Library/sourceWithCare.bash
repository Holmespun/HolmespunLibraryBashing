#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
#
#  Library/sourceHolmespunLibraryBashing.bash
#
#	Sourcing HolmespunLibraryBashing library functions upon request but only once.
#
#  Usage:
#
#       Safe sourcing can be accomplished with a two step process:
#
#               1. sourceWithCarePrepare <repo-name> <sub-directory> <file-name> [ <file-name>... ]
#
#               2. sourceWithCarePublishSafe; eval $(sourceWithCareGetCommand)
#
#       Each <file-name> will be sourced from within the <sub-directory> of the repository that can be located using
#       a call to the where<repo-name> script.
#
#       The sourceWithCarePrepare function may be called any number of times before the sourceWithCarePublishSafe
#       function is called.
#
#       Calls to the sourceWithCarePublishSafe function generate output for subsequent calls to the
#       sourceWithCareGetCommand function, but only for files that were named in calls to sourceWithCarePrepare and
#       have yet to be published. As such, two directly-subsequent calls to the sourceWithCarePublishSafe function
#       will always result in a no-op value returned by the sourceWithCareGetCommand function.
#
#  Example:
#
#       sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash
#
#       sourceWithCarePrepare HolmespunLibraryBashing Library copyToGarbage_and_moveToGarbage.bash
#
#       sourceWithCarePublishSafe; eval $(sourceWithCareGetCommand)
#
#       echoInColorRed "Safe Success"
#
#  Copyright 2020 Brian G. Holmes
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
#  20200926 BGH; created.
#
#----------------------------------------------------------------------------------------------------------------------

declare -A __SourceWithCareWhereRepo
declare -A __SourceWithCareIterationOfFile

declare -i __SourceWithCareIterationPrepared=0
declare -i __SourceWithCareIterationReleased=0

declare    __SourceWithCareCommand=

#----------------------------------------------------------------------------------------------------------------------

function sourceWithCarePrepare() {
  #
  local RepositoryName=${1-UNDEFINED}
  local SubfolderDSpec=${2-}
  shift 2
  local SourceFileList=${*}
  #
  local SourceFileItem SourceFileFSpec
  #
  #  Predefine this file for the zeroeth iteration.
  #
  if [ ${__SourceWithCareIterationPrepared} -eq 0 ]
  then
     #
     __SourceWithCareWhereRepo["HolmespunLibraryBashing"]="$(cd $(dirname ${BASH_SOURCE[0]}); echo ${PWD})/.."
     #
     SourceFileFSpec="${__SourceWithCareWhereRepo["HolmespunLibraryBashing"]}/Library/$(basename ${BASH_SOURCE[0]})"
     #
     __SourceWithCareIterationOfFile["${SourceFileFSpec}"]=0
     #
  fi
  #
  #  Define the new iteration.
  #
  __SourceWithCareCommand=
  #
  __SourceWithCareIterationPrepared+=1
  #
  #  Record the repository location.
  #
  if [ "${__SourceWithCareWhereRepo[${RepositoryName}]+IS_SET}" != "IS_SET" ]
  then
     #
     hash where${RepositoryName}
     #
     if [ ${?} -ne 0 ]
     then
        #
        echo "ERROR: The where${RepositoryName} script was not found."
        echo "INFO:  The script is defined in the ${RepositoryName} repository."
        echo "INFO:  Install that repository or add ${RepositoryName}/bin to your PATH."
        #
        exit 9
        #
     fi
     #
     __SourceWithCareWhereRepo[${RepositoryName}]=$(where${RepositoryName})
     #
  fi
  #
  #  Record interest in files to be sourced.
  #
  for SourceFileItem in ${SourceFileList}
  do
    #
    SourceFileFSpec=${__SourceWithCareWhereRepo[${RepositoryName}]}/${SubfolderDSpec}/${SourceFileItem}
    #
    if [ "${__SourceWithCareIterationOfFile["${SourceFileFSpec}"]+IS_SET}" != "IS_SET" ]
    then
       #
       if [ ! -f ${SourceFileFSpec} ]
       then
          #
          echo "ERROR: The ${SourceFileFSpec} file was not found." 1>&1
          #
          exit 8
          #
       fi
       #
       __SourceWithCareIterationOfFile["${SourceFileFSpec}"]=${__SourceWithCareIterationPrepared}
       #
    fi
    #
  done
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __sourceWithCarePublish() {
  #
  local -r -i IterationLevel=${1}
  #
  __SourceWithCareCommand=
  #
  local       Result=": sourceWithCare ${IterationLevel}"
  #
  local       SourcedFSpec
  #
  for SourcedFSpec in ${!__SourceWithCareIterationOfFile[*]}
  do
    #
    if [ ${__SourceWithCareIterationOfFile["${SourcedFSpec}"]} -gt ${IterationLevel} ]
    then
       Result+="; source '${SourcedFSpec}'"
    fi
    #
  done
  #
  __SourceWithCareIterationReleased=${__SourceWithCareIterationPrepared}
  #
  __SourceWithCareCommand="${Result}"
  #
}

#----------------------------------------------------------------------------------------------------------------------

function sourceWithCarePublishFull() { __sourceWithCarePublish 0; }
function sourceWithCarePublishSafe() { __sourceWithCarePublish ${__SourceWithCareIterationReleased}; }

#----------------------------------------------------------------------------------------------------------------------

function sourceWithCareGetCommand() { echo "${__SourceWithCareCommand}"; }

#----------------------------------------------------------------------------------------------------------------------
