#----------------------------------------------------------------------------------------------------------------------
#
#  Testing/sourceWithCare.clut
#
#----------------------------------------------------------------------------------------------------------------------
#
#  Copyright (c) 2020 Brian G. Holmes
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
#  sourceWithCarePrepare
#  sourceWithCarePublishFull
#  sourceWithCarePublishSafe
#  sourceWithCareGetCommand
#
#  20200930 BGH; created.
#
#----------------------------------------------------------------------------------------------------------------------

set -u

source $(whereHolmespunLibraryBashing)/Library/spit_spite_spitn_and_spew.bash

#----------------------------------------------------------------------------------------------------------------------

function run_test() {
  #
  local -r TestName=${*}
  #
  ${TestName} TEST_SCRIPT.bash
  #
  echo "##------------------------------------------------------------------------------------------------------------"
  echo "**"
  echo "**  Test script for ${TestName}"
  echo "**"
  #
  cat TEST_SCRIPT.bash
  #
  echo ">>"
  echo ">>  Output for ${TestName}"
  echo ">>"
  #
  TEST_SCRIPT.bash
  #
}

#----------------------------------------------------------------------------------------------------------------------

function initialize() {
  #
  local -r FSpec=${1}
  #
  rm --force ${FSpec}
  #
  spit ${FSpec} "#!/bin/bash"
  spit ${FSpec} "#"
  spit ${FSpec} "#  ${FSpec}"
  spit ${FSpec} "#"
  spit ${FSpec} ""
  spit ${FSpec} "source ../Library/sourceWithCare.bash"
  spit ${FSpec} ""
  #
}

#----------------------------------------------------------------------------------------------------------------------

function complete() {
  #
  local -r FSpec=${1}
  #
  spit ${FSpec} "sourceWithCarePublishSafe"
  spit ${FSpec} ""
  spit ${FSpec} "echo \"sourceWithCarePublishSafe: \$(sourceWithCareGetCommand)\""
  spit ${FSpec} ""
  spit ${FSpec} "sourceWithCarePublishSafe"
  spit ${FSpec} ""
  spit ${FSpec} "echo \"sourceWithCarePublishSafe: \$(sourceWithCareGetCommand)\""
  spit ${FSpec} ""
  spit ${FSpec} "sourceWithCarePublishFull"
  spit ${FSpec} ""
  spit ${FSpec} "echo \"sourceWithCarePublishFull: \$(sourceWithCareGetCommand)\""
  spit ${FSpec} ""
  spit ${FSpec} "#"
  #
  chmod 755 ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function success_show_simple() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}
 
#----------------------------------------------------------------------------------------------------------------------

function success_show_duplicate_request() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash"
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash"
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash"
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function success_show_multiple_preparation() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash"
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoAndExecute.bash"
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library copyToGarbage_and_moveToGarbage.bash"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function failure_bad_file_name() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash"
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library EchoInColor.bash echoAndExecute.bash"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function failure_bad_repo_name() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash"
  spit ${FSpec} "sourceWithCarePrepare ZolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function success_sourceWithCare_is_predefined() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library sourceWithCare.bash"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}
  
#----------------------------------------------------------------------------------------------------------------------

function success_demostration() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "sourceWithCarePrepare HolmespunLibraryBashing Library echoInColor.bash echoAndExecute.bash"
  spit ${FSpec} ""
  spit ${FSpec} "sourceWithCarePublishSafe"
  spit ${FSpec} ""
  spit ${FSpec} "eval \$(sourceWithCareGetCommand)"
  spit ${FSpec} ""
  spit ${FSpec} "echoInColorRed Safe Success"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}
 
#----------------------------------------------------------------------------------------------------------------------

run_test success_show_simple
run_test success_show_duplicate_request
run_test success_show_multiple_preparation

run_test failure_bad_file_name
run_test failure_bad_repo_name

run_test success_demostration

run_test success_sourceWithCare_is_predefined

echo "##------------------------------------------------------------------------------------------------------------"
echo "##  (eof)"

#----------------------------------------------------------------------------------------------------------------------
