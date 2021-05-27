#----------------------------------------------------------------------------------------------------------------------
###
###			Library/indirectFunctionHandler.bash
###
###	@file
###	@author		Brian G. Holmes
###	@copyright	GNU General Public License
###	@brief		Provides a mechanism for associating an identifier with a function, re-defining that
###			association with a different function if desired, and then calling the function using the
###			associated identifier.
###
###	@details	The indirectFunctionHandler is made up of a pair of functions and a simple database. The
###			__IndirectFunctionHandler array associates identifiers with function names. The array is
###			populated using calls to the indirectFunctionHandlerDeclare function. Functions in the array
###			can be called by passing an identifier into the indirectFunctionHandlerCall function.
###
###			Why?  Because we need a mechanism by which default functionality can be defined but then can
###			also be easily overridden by the user through configuration augmentations: The default function
###			is associated with a predefined identifier, the base framework calls that function via the
###			identifier for the default configuration, but the user can define a function, associate that
###			same identifier with the new function, and the base system will thereafter call the user's
###			function via the identifier.
###
###  TODO: Example usage.
###
###
#----------------------------------------------------------------------------------------------------------------------
#
#  Copyright 2017-2018 Brian G. Holmes
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
#  20171228 BGH; created.
#  20180211 BGH; modified to use clutc and clutr instead of clutrun.
#  20180822 BGH; added BASH_SOURCE information to indirectFunctionHandlerCall error message.
#
#----------------------------------------------------------------------------------------------------------------------

set -u

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__IndirectFunctionHandler
###  @brief	An array that associates textual identifiers with Bash functions.
###
#----------------------------------------------------------------------------------------------------------------------

declare -A __IndirectFunctionHandler

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	indirectFunctionHandlerDeclare
###  @param	Identity	A textual identifier.
###  @param	Function	A Bash function name.
###  @brief	Associate an identifier with a Bash function.
###
###  @details	The indirectFunctionHandlerDeclare associates the given Function name with the given Identity. An error
###		condition is raised if the Bash type of the Function name is is not "function."
###
#----------------------------------------------------------------------------------------------------------------------

function indirectFunctionHandlerDeclare() {
  #
  local -r Identity=${1-}
  local -r Function=${2-}
  #
  if [ ${#Function} -eq 0 ]
  then
     #
     echo "ERROR: The ${FUNCNAME} function was called with too few parameters."                         >&2
     echo "USAGE: ${FUNCNAME} <identifier> <function-name>"                                             >&2
     #
     return 1
     #
  else
     #
     local -r TypeCheck=$(type -t ${Function})
     #
     if [ $? -ne 0 ] || [[ "${TypeCheck}" != *"function"* ]]
     then
        #
        echo "ERROR: The ${FUNCNAME} function was given an invalid function name."                      >&2
        echo "USAGE: ${FUNCNAME} <identifier> <function-name>"                                          >&2
        #
        return 2
        #
     else
        #
        __IndirectFunctionHandler["${Identity}"]=${Function}
        #
     fi
     #
  fi
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	indirectFunctionHandlerCall
###  @param	TargetRequested		A textual identifier.
###  @param	AdditionalArguments	A set of arguments for the function associated with the identifier.
###  @brief	Calls the function associated with the given identifier.
###
###  @details	The indirectFunctionHandlerCall function calls the function associated with the TargetRequested, and
###		passes that function the AdditionalArguments. The type of the TargetRequested is first checked to see
###		if it is the name of a function; if it is then that function is called directly. If it is not then the
###		function checks to see if the TargetRequested is an identifier that was previously associated with a
###		function name. It the TargetRequested is an identifier associated with a function then that function is
###		called. Otherwise an error is raised because TargetRequested is neither a function name nor a function
###		identifier.
###
#----------------------------------------------------------------------------------------------------------------------

function indirectFunctionHandlerCall() {
  #
  local -r TargetRequested=${1-}
  #
  shift 1
  #
  local HandlerFunctionCalled=
  #
  if [ ${#TargetRequested} -gt 0 ]
  then
     #
     #  If the user has directly named a function then call that function.
     #
     HandlerFunctionCalled=${TargetRequested}
     #
     local -r TypeCheck=$(type -t ${TargetRequested})
     #
     if [ $? -ne 0 ] || [[ "${TypeCheck}" != *"function"* ]]
     then
        #
        #  If the user has identified a function to call indirectly then call that function.
        #
        HandlerFunctionCalled=${__IndirectFunctionHandler[${TargetRequested}]-}
        #
     fi
     #
  fi
  #
  if [ ${#HandlerFunctionCalled} -eq 0 ]
  then
     #
     local KnownTargetList=
     #
     local KnownTarget
     #
     for KnownTarget in ${!__IndirectFunctionHandler[*]}
     do
       #
       KnownTargetList+=", ${KnownTarget}"
       #
     done
     #
     echo "ERROR: Requested indirect call target '${TargetRequested}' is not defined."                  >&2
     echo "INFO:  Request issued within the $(basename ${BASH_SOURCE[1]}) file."                        >&2
     echo "INFO:  Choose one of ${KnownTargetList:2}."                                                  >&2
     #
     false
     #
  else
     #
     ${HandlerFunctionCalled} "${@}"
     #
  fi
  #
}

#----------------------------------------------------------------------------------------------------------------------
