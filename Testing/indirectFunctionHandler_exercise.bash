#----------------------------------------------------------------------------------------------------------------------
#
#  Testing/indirectFunctionHandler_exercise.bash
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
#  indirectFunctionHandlerDeclare
#  indirectFunctionHandlerCall
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
  spit ${FSpec} "source ../Library/indirectFunctionHandler.bash"
  spit ${FSpec} ""
  spit ${FSpec} "function Alpha() { echo \"Function \${FUNCNAME} was called.\"; }"
  spit ${FSpec} "function Beta()  { echo \"Function \${FUNCNAME} was called.\"; }"
  spit ${FSpec} "function Gamma() { echo \"Function \${FUNCNAME} was called.\"; }"
  spit ${FSpec} ""
  #
}

#----------------------------------------------------------------------------------------------------------------------

function complete() {
  #
  local -r FSpec=${1}
  #
  spit ${FSpec} "#"
  #
  chmod 755 ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function success_simple() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "indirectFunctionHandlerDeclare One Alpha"
  spit ${FSpec} ""
  spit ${FSpec} "indirectFunctionHandlerCall One"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}
 
#----------------------------------------------------------------------------------------------------------------------

function success_override() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "indirectFunctionHandlerDeclare Two Alpha"
  spit ${FSpec} "indirectFunctionHandlerDeclare Two Beta"
  spit ${FSpec} "indirectFunctionHandlerDeclare Two Gamma"
  spit ${FSpec} ""
  spit ${FSpec} "indirectFunctionHandlerCall Two"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}

#----------------------------------------------------------------------------------------------------------------------

function failure_no_such_function() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "indirectFunctionHandlerDeclare Three Alpha"
  spit ${FSpec} "indirectFunctionHandlerDeclare Three Theta"
  spit ${FSpec} ""
  spit ${FSpec} "indirectFunctionHandlerCall Three"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}
 
#----------------------------------------------------------------------------------------------------------------------

function failure_too_few_parameters() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "indirectFunctionHandlerDeclare Four Alpha"
  spit ${FSpec} "indirectFunctionHandlerDeclare Four"
  spit ${FSpec} ""
  spit ${FSpec} "indirectFunctionHandlerCall Four"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}
 
#----------------------------------------------------------------------------------------------------------------------

function failure_tag_not_defined() {
  #
  local -r FSpec=${1}
  #
  initialize ${FSpec}
  #
  spit ${FSpec} "indirectFunctionHandlerDeclare Five  Alpha"
  spit ${FSpec} "indirectFunctionHandlerDeclare Six   Beta"
  spit ${FSpec} "indirectFunctionHandlerDeclare Seven Gamma"
  spit ${FSpec} ""
  spit ${FSpec} "indirectFunctionHandlerCall Six"
  spit ${FSpec} "indirectFunctionHandlerCall Eight"
  spit ${FSpec} ""
  #
  complete ${FSpec}
  #
}
 
#----------------------------------------------------------------------------------------------------------------------

run_test success_simple
run_test success_override

run_test failure_no_such_function
run_test failure_too_few_parameters
run_test failure_tag_not_defined

echo "##------------------------------------------------------------------------------------------------------------"
echo "##  (eof)"

#----------------------------------------------------------------------------------------------------------------------
