#----------------------------------------------------------------------------------------------------------------------
###
###  Library/echoListOfConfigurationFSpec.bash
###
###  @file
###  @author	Brian G. Holmes
###  @copyright	GNU General Public License
###  @brief	Defines a function for generating a list of specifications to existing configuration files.
###
#----------------------------------------------------------------------------------------------------------------------
#
#  Copyright (c) 2020-2022 Brian G. Holmes
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
#  20201121 BGH; created.
#  20210505 BGH; allow user to define root/base directory that all files must share, instead of absolute possibilities.
#
#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__echoHierarchyListOfDSpec
###  @brief	Displays a list of directory specifications from the $PWD down to - but not including - a *base*
###             directory in order from those closest to the root directory. If the $PWD is in the $HOME
###             hierarchy then the base directory is $HOME; otherwise it is the root (/) directory.
###
#----------------------------------------------------------------------------------------------------------------------

function __echoHierarchyListOfDSpec() {
  #
  local TargetDSpec=${PWD}
  #
  local BreakPointDSpec="/"
  #
  [ "${PWD:0:${#HOME}}" = "${HOME}" ] && BreakPointDSpec="${HOME}"
  #
  while [ "${TargetDSpec}" != "${BreakPointDSpec}" ]
  do
    #
    echo "${TargetDSpec}"
    #
    TargetDSpec=$(dirname ${TargetDSpec})
    #
  done | sort
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	echoListOfConfigurationFSpec
###  @param	ConfigurationFName The name of the configuration files of interest.
###  @param     BaseDirectoryVName The name of a variable that - if set - defines that base/root/parent directory of
###             all of the specifications echoed.
###  @brief	Displays a list of specifications to existing configuration files based on the HMM configuration
###             hierarchy. The HMM configuration hierarchy includes the directories ${HOME}/.config/holmespun and
###             ${HOME} followed by all of the directories from the $PWD down to - but not including - a *base*
###             directory in order from those closest to the root directory. If the $PWD is in the $HOME hierarchy then
###             the base directory is $HOME; otherwise it is the root (/) directory.
###  @remark    Uses the @ref __echoHierarchyListOfDSpec function.
###
###  @details
###
###  Original implementation and use in Bash scripts:
###
###  @code{.bash}
###     for DSpec in ${HOME} $(D=$PWD; while [ $D != / ] && [ $D != $HOME ]; do echo $D; D=$(dirname $D); done | sort)
###     do
###       [ -e ${DSpec}/.hmm_detail.bash ] && source ${DSpec}/.hmm_detail.bash
###     done
###  @endcode
###
###  Original implementation and use in a makefile:
###
###  @code{.make}
###   HmmFindAllParentDSpecBase =     $(if $(filter-out 1,$(words $(subst /, ,$1)))                           \
###	                                 , $(call HmmFindAllParentDSpecBase,$(patsubst %/,%,$(dir $1)))       \
###	                              )                                                                       \
###	                              $1
###	
###   HmmFindAllParentDSpecAway =     $(call HmmFindAllParentDSpecBase,$1)
###	
###   HmmFindAllParentDSpecHome =     $(addprefix $(HOME)/,$(call HmmFindAllParentDSpecBase,$(subst $(HOME)/,,$(PWD))))
###	
###   HmmFindAllParentDSpecMain =     $(if $(findstring $(HOME),$1)                                           \
###	                                 , $(call HmmFindAllParentDSpecHome,$1)                               \
###	                                 , $(call HmmFindAllParentDSpecAway,$1)                               \
###	                              )
###
###   -include $(HOME)/$(HmmUserConfigurationFName)
###   -include $(addsuffix /$(HmmUserConfigurationFName),$(call HmmFindAllParentDSpecMain,$(PWD)))
###  @endcode
###	
#----------------------------------------------------------------------------------------------------------------------

declare -i __GlobalDebugFlag=0

#----------------------------------------------------------------------------------------------------------------------

function echoListOfConfigurationFSpec() {
  #
  local -r ConfigurationFName=${1}
  local -r BaseDirectoryVName=${2-}
  #
  local    BaseDirectoryFSpec Decision
  #
  local -r ListOfHierarchyDSpec="${HOME}/.config/holmespun ${HOME} $(__echoHierarchyListOfDSpec)"
  local    ItemOfHierarchyDSpec
  #
  if [ ${#BaseDirectoryVName} -gt 0 ] && [ "${!BaseDirectoryVName+IS_SET}" = "IS_SET" ]
  then
     #
     BaseDirectoryFSpec="${!BaseDirectoryVName}"
     #
     if [ ${__GlobalDebugFlag} -ne 0 ]
     then
        echo "ConfigurationFName=${ConfigurationFName}" >&2
        echo "BaseDirectoryVName=${BaseDirectoryVName}" >&2
        echo "BaseDirectoryFSpec=${BaseDirectoryFSpec}" >&2
     fi
     #
     for ItemOfHierarchyDSpec in ${ListOfHierarchyDSpec}
     do
       #
       Decision="REJECTED"
       #
       if [ "${ItemOfHierarchyDSpec:0:${#BaseDirectoryFSpec}}" = "${BaseDirectoryFSpec}" ]
       then
          #
          Decision="NOTFOUND"
          #
          if [ -e ${ItemOfHierarchyDSpec}/${ConfigurationFName} ]
          then
             #
             echo ${ItemOfHierarchyDSpec}/${ConfigurationFName}
             #
             Decision="ACCEPTED"
             #
          fi
          #
       fi
       #
       [ ${__GlobalDebugFlag} -ne 0 ] && echo "${Decision} ${ItemOfHierarchyDSpec}" >&2
       #
     done
     #
  else
     #
     for ItemOfHierarchyDSpec in ${ListOfHierarchyDSpec}
     do
       #
       [ -e ${ItemOfHierarchyDSpec}/${ConfigurationFName} ] && echo ${ItemOfHierarchyDSpec}/${ConfigurationFName}
       #
     done
     #
  fi
  #
}

#----------------------------------------------------------------------------------------------------------------------
