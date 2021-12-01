#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
#
#  unpackSnapshotArchive
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
  echo "USAGE: unpackSnapshotArchive <source-fspec> <target-dspec>" 1>&2
  echo "             <source-fspec> identifies a snapshort archive." 1>&2
  echo "             <target-dspec> identifies the directry into which the archive should be unpacked." 1>&2
  #
  __echoErrorAndExit ${*}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function __unpackSnapshotArchive() {
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
  local -r SourceDName=$(dirname  ${GivenSourceFSpec})
  #
  local -r OutputFName=${SourceFName%.*}
  #
  [ -e ${GivenTargetDSpec}/${OutputFName} ] && __echoErrorAndExit "Output file '${OutputFName}' already exists."
  #
  local -r LinkedFName=${OutputFName%.*}
  #
  [ -e ${GivenTargetDSpec}/${LinkedFName} ] && [ ! -h ${GivenTargetDSpec}/${LinkedFName} ] &&	\
	__echoErrorAndExit "Output file '${GivenTargetDSpec}/${LinkedFName}' is not a symbolic link."
  #
  local -r WhereWeWere=${PWD}
  #
  cd ${SourceDName}/
     #
     InnputFSpec=${PWD}/${SourceFName}
     #
  cd ${WhereWeWere}
  #
  cd ${GivenTargetDSpec}
     #
     tar xvfz ${InnputFSpec}
     #
     [ ${?} -ne 0 ] && __echoErrorAndExit "Unable to unpack archive."
     #
     mv ${LinkedFName} ${LinkedFName}.was
     #
     ln --symbolic ${OutputFName} ${LinkedFName}
     #
     [ ${?} -ne 0 ] && __echoErrorAndExit "Unable to create symbolic link."
     #
  cd ${WhereWeWere}
  #
}

#----------------------------------------------------------------------------------------------------------------------

__unpackSnapshotArchive ${*}

#----------------------------------------------------------------------------------------------------------------------
