#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
#
#  createSnapshotArchive.bash
#
#----------------------------------------------------------------------------------------------------------------------

set -u

#----------------------------------------------------------------------------------------------------------------------

function __echoErrorAndExit() {
  #
  echo "ERROR: ${*}" 1>&2
  #
  exit 1
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __echoUsageErrorAndExit() {
  #
  echo "USAGE: createSnapshotArchive <source-fspec> <target-dspec>" 1>&2
  #
  __echoErrorAndExit ${*}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __createSnapshotArchive() {
  #
  local -r GivenSourceFSpec=${1-}
  local -r GivenTargetDSpec=${2-}
  #
  [ ${#GivenSourceFSpec} -eq 0 ] && __echoUsageErrorAndExit "Source file specification required."
  #
  [ ${#GivenTargetDSpec} -eq 0 ] && __echoUsageErrorAndExit "Target directory specification required."
  #
  [ ! -e ${GivenSourceFSpec} ] && __echoErrorAndExit "Source file '${GivenSourceFSpec}' does not exist."
  #
  [ ! -e ${GivenTargetDSpec} ] && __echoErrorAndExit "Target directory '${GivenTargetDSpec}' does not exist."
  #
  local -r SourceFName=$(basename ${GivenSourceFSpec})
  #
  local -r OutputFName=${SourceFName}.$(date '+%Y%m%d_%H%M%S')
  #
  local -r ActualSourceFSpec=${GivenSourceFSpec}
  #
  [ -h ${GivenSourceFSpec} ] && ActualSourceFSpec=$(readlink ${GivenSourceFSpec})
  #
  local -r InnputFName=$(basename ${ActualSourceFSpec})
  #
  tar cvfz ${GivenTargetDSpec}/${OutputFName}.tz		\
      --transform=s/${InnputFName}/${OutputFName}/ --show-transformed-names ${ActualSourceFSpec}
  #
  [ ${?} -ne 0 ] && __echoErrorAndExit "Unable to create archive."
  #
}

#----------------------------------------------------------------------------------------------------------------------

__createSnapshotArchive ${*}

#----------------------------------------------------------------------------------------------------------------------
