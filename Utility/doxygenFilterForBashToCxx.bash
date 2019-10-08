#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
###
###			doxygenFilterForBashToCxx.bash
###
###	@file
###	@author		Brian G. Holmes
###	@copyright	GNU General Public License
###	@brief		Translates a Bash script that contains Doxygen special comments into a form that the doxygen
###			program can interpret as C++ code, and writes the result to standard output.
###
###	@remark		Usage: doxygenFilterForBashToCxx.bash <source-fspec>
###
###	@remark		Inspired by work described at https://github.com/Anvil/bash-doxygen/.
###
###	@remark		Global variables are used so that separate functions can be defined that deal with specific
###			aspects of the input file code.
###
###	@details	The doxygenFilterForBashToCxx.bash script fulfills the following requirements:
###
###@code{.unparsed}
###
###	DFFB-Input-0010        	The input Bash script may use the "###" or "##!" symbols for Doxygen special comments.
###
###	DFFB-Input-0020        	Doxygen special comments in the input Bash script must be on a line of their own.
###
###	DFFB-Comment-0010       The program will translate special comments into lines that start with "///" symbol.
###
###	DFFB-Comment-0020       Whitespace in special comment lines will be converted to a single blank,
###	                        except for those lines between an "code" and "endcode" directive.
###
###	DFFB-Comment-0030       Bash "fn" directives will only translate properly when the simply name the function
###	                        that they describe.
###
###	DFFB-Translate-0010     Bash "fn" directives will be augmented to include a int8_t return type (representing a
###	                        Linux exit status) when translated.
###
###	DFFB-Translate-0020     Bash "fn" directives will be augmented to include a list of parameters whose order and
###	                        name are based on the "param" directives that follow it.
###
###	DFFB-Translate-0030     All function parameters in the translation will have the pseudo-type bash::string.
###
###	DFFB-Translate-0040     Special comment blocks that contain an "fn" directive will be given an "returns"
###	                        directive during translation that describes the Linux exit status.
###
###	DFFB-Translate-0110     Bash functions will be translated to empty C++ functions with class access modifiers.
###
###	DFFB-Translate-0120     Bash function translations will be given the same return type and parameter
###	                        specification as is expressed in the translated "fn" directive.
###
###	DFFB-Translate-0130     Functions with names that begin with an underscore character will be given a private
###	                        class access modifier; all others will be given a public modifier.
###
###	DFFB-Translate-0210     Bash declare statements will be translated into C++ constant and variable definitions.
###
###	DFFB-Translate-0220     Bash declare statements that express the -i option will be translated using the
###	                        pseudo-type bash::integer as their base type; all others will use the pseudo-type
###	                        bash::string as their base type.
###
###	DFFB-Translate-0230     Bash declare statements that express the -r option will be translated into constants.
###
###	DFFB-Translate-0240     Bash declare statements that express the -a option will be translated using the
###	                        pseudo-type bash:array as a container of their base type.
###
###	DFFB-Translate-0250     Bash declare statements that express the -A option will be translated using the
###	                        pseudo-type bash:map as a container of their base type.
###
###	DFFB-Translate-0260     Options expressed in Bash declare statements, other than those explicitly called out in
###	                        these statements, will be ignored.
###
###	DFFB-Translate-0270     Values expressed in Bash declare statements (after an equal sign) will be preserved in
###	                        the translation, wrapped in a pseudo-type translation, and quoted if necessary.
###
###	DFFB-Translate-0280     Constants and variables with names that begin with an underscore character will be
###	                        given a private class access modifier; all others will be given a public modifier.
###
###	DFFB-Translate-0310     Alias statements will be translated to constant definitions with the public class
###	                        access modifier and pseudo-type bash::string.
###
###	DFFB-Translate-0410     All normal comments and Bash statements that are not explicitly called out here will be
###	                        considered insignificant during translation, and will thus be translated to blank
###	                        lines, or overwritten by extra information like an "returns" directive special comment
###	                        or a class wrapper.
###
###	DFFB-Translate-0420     A class wrapper will be added to the translation if the input file contained any
###	                        insignificant lines following the special command that contains the "file" directive,
###	                        two or more public functions were translated, and one or more private functions,
###	                        constants, or variables were translated.
###@endcode
###
#----------------------------------------------------------------------------------------------------------------------
#
#  Copyright (c) 2018-2019 Brian G. Holmes
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
#  20180413 BGH; created.
#  20180429 BGH; revamped and formalized.
#  20180825 BGH; added bash script input file specification argument check.
#  20190929 BGH; moved to HLB repo.
#
#----------------------------------------------------------------------------------------------------------------------

set -f
set -u

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__BashLibraryDSpec
###  @brief	Hold the location of Bash library functions.
###
#----------------------------------------------------------------------------------------------------------------------

declare -r __BashLibraryDSpec=$(whereHolmespunLibraryBashing)/Library

source ${__BashLibraryDSpec}/echoDatStampedFSpec.bash

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__HMM_PARAM
###  @brief	A substitute for the partial word "param" that allows the HMM to hide words that contain it from a
###		strange error in Doxygen 1.8.11.
###
###  @details	Doxygen 1.8.11 often malfunctions when it encounters words that contain "param." To handle this, we
###		preprocess away all uses of "param" without an at-about sign in front of them, converting them to
###		HMM::PARAM here, and then reverse that conversion in a post-processing step of the
###		HmmGenerateDoxygenDocumentation function in the Make/makefile_detail.bash file.
###
#----------------------------------------------------------------------------------------------------------------------

declare -r    __HMM_PARAM="HMM::PARAM"

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__FALSE
###  @brief	A constant that is used to represent the boolean value false.
###
#----------------------------------------------------------------------------------------------------------------------

declare -r    __FALSE="false"

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__TRUE
###  @brief	A constant that is used to represent the boolean value true.
###
#----------------------------------------------------------------------------------------------------------------------

declare -r    __TRUE="TRUE"

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__DoxyCodeBlockActive
###  @brief	A boolean value that signifies that the current line follows a "code" directive, but precedes or
###		represents the associated "endcode" directive. Whitespace on lines between "code" and "endcode" is not
###		removed. 
###
#----------------------------------------------------------------------------------------------------------------------

declare       __DoxyCodeBlockActive=${__FALSE}

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__SourceFileLineArray
###  @brief	An array that is used to hold each line of the input file, as well as the resulting output that is
###		generated here.
###
#----------------------------------------------------------------------------------------------------------------------

declare -a    __SourceFileLineArray

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__DoxyFunctionParameterVector
###  @brief	A textual list of C++-like parameter declarations.
###
#----------------------------------------------------------------------------------------------------------------------

declare -A    __DoxyFunctionParameterVector

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__DoxyFunctionDeclarationLine
###  @brief	An associative array that maps a function name to the @ref __SourceFileLineArray index where the "fn"
###		directive that declares it can be found. The script will add a return type and parameter declarations
###		to the function name.
###
#----------------------------------------------------------------------------------------------------------------------

declare -A -i __DoxyFunctionDeclarationLine

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__DoxyFunctionDeclarationNull
###  @brief	An associative array that maps a function name to the @ref __SourceFileLineArray index of the first
###		line that follows the "fn" directive for that function that contains no information useful to doxygen.
###		The script will put a "returns" directive at that location.
###
#----------------------------------------------------------------------------------------------------------------------

declare -A -i __DoxyFunctionDeclarationNull

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__DoxyFunctionDeclarationNameNull
###  @brief	The initial value of @ref __DoxyFunctionDeclarationName.
###
#----------------------------------------------------------------------------------------------------------------------

declare -r    __DoxyFunctionDeclarationNameNull=NONE

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__DoxyFunctionDeclarationName
###  @brief	The function name last seen in a "fn" directive.
###
#----------------------------------------------------------------------------------------------------------------------

declare       __DoxyFunctionDeclarationName=${__DoxyFunctionDeclarationNameNull}

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__InsignificantLineAfterFileDirectiveFirst
###  @brief	Holds the index into @ref __SourceFileLineArray of the first insignificant line after the "file"
###		directive. If this code is a candidate for a class wrapper then that wrapper will start on this line.
###
#----------------------------------------------------------------------------------------------------------------------

declare -i    __InsignificantLineAfterFileDirectiveFirst=0

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__InsignificantLineAfterFileDirectiveLast
###  @brief	Holds the index into @ref __SourceFileLineArray of the last insignificant line in that file.  If this
###		code is a candidate for a class wrapper then that wrapper may end on this line.
###
#----------------------------------------------------------------------------------------------------------------------

declare -i    __InsignificantLineAfterFileDirectiveLast=0

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__HiddenObjectCount
###  @brief	Used to count the number of private variables and functions.
###
#----------------------------------------------------------------------------------------------------------------------

declare -i    __HiddenObjectCount=0

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__PublicFunctionCount
###  @brief	Used to count the number of public functions.
###
#----------------------------------------------------------------------------------------------------------------------

declare -i    __PublicFunctionCount=0

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_Insignificant
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @brief	Processes a single line that will have no significance to the doxygen program.
###
###  @details	The __processSourceFileLine_Insignificant function uses a blank line as the translation of an
###		insignificant source line.  It also may set the @ref __InsignificantLineAfterFileDirectiveFirst and
###		@ref __DoxyFunctionDeclarationNull for the current @ref __DoxyFunctionDeclarationName, and will set the
###		@ref __InsignificantLineAfterFileDirectiveLast variable.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_Insignificant() {
  #
  local -r -i SourceIndx=${1}
  #
  #  DFFB-Translate-0410 All normal comments and Bash statements that are not explicitly called out here will be
  #	                 considered insignificant during translation, and will thus be translated to blank
  #	                 lines, or overwritten by extra information like an "returns" directive special comment
  #	                 or a class wrapper.
  #
  __SourceFileLineArray[${SourceIndx}]=
  #
  if [ "${__DoxyFunctionDeclarationName}" != "${__DoxyFunctionDeclarationNameNull}" ]	\
  && [ ${__DoxyFunctionDeclarationNull[${__DoxyFunctionDeclarationName}]} -eq 0 ]
  then
     #
     __DoxyFunctionDeclarationNull[${__DoxyFunctionDeclarationName}]=${SourceIndx}
     #
  elif [ ${__InsignificantLineAfterFileDirectiveFirst} -eq 0 ]
  then
     #
     __InsignificantLineAfterFileDirectiveFirst=${SourceIndx}
     #
  else
     #
     __InsignificantLineAfterFileDirectiveLast=${SourceIndx}
     #
  fi
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_SpecialComment_code
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent the comment portion of a source line.
###  @brief	Translates an "code" directive and sets the @ref __DoxyCodeBlockActive flag to true.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_SpecialComment_code() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  local -r -a SourceItem=(${*})
  #
  #  The directive is on a line of its own, or whitespace is unimportant; just remove extra whitespace.
  #
  #  DFFB-Comment-0020 Whitespace in special comment lines will be converted to a single blank.
  #
  __SourceFileLineArray[${SourceIndx}]+=${SourceItem[*]}
  #
  #  Set the flag that indicates that we are processing a code-endcode block.
  #
  __DoxyCodeBlockActive=${__TRUE}
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_SpecialComment_endcode
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent the comment portion of a source line.
###  @brief	Translates an "endcode" directive and sets the @ref __DoxyCodeBlockActive flag to false.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_SpecialComment_endcode() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  local -r -a SourceItem=(${*})
  #
  #  The directive is on a line of its own, or whitespace is unimportant; just remove extra whitespace.
  #
  #  DFFB-Comment-0020 Whitespace in special comment lines will be converted to a single blank.
  #
  __SourceFileLineArray[${SourceIndx}]+=${SourceItem[*]}
  #
  #  Set the flag that indicates that we are no-longer processing a code-endcode block.
  #
  __DoxyCodeBlockActive=${__FALSE}
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_SpecialComment_file
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent the comment portion of a source line.
###  @brief	Translates a "file" directive,
###  		and initializes the @ref __InsignificantLineAfterFileDirectiveFirst variable to zero.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_SpecialComment_file() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  local -r -a SourceItem=(${*})
  #
  #  The directive is on a line of its own, or whitespace is unimportant; just remove extra whitespace.
  #
  #  DFFB-Comment-0020 Whitespace in special comment lines will be converted to a single blank.
  #
  __SourceFileLineArray[${SourceIndx}]+=${SourceItem[*]}
  #
  #  Reset __InsignificantLineAfterFileDirectiveFirst since we have just seen the file directive.
  #
  __InsignificantLineAfterFileDirectiveFirst=0
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_SpecialComment_fn
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent the comment portion of a source line.
###  @brief	Translates an "fn" directive.
###
###  @details	The __processSourceFileLine_SpecialComment_fn function sets the @ref __DoxyFunctionDeclarationName to
###		the name of the declared function, sets the @ref __DoxyFunctionDeclarationLine for that function to the
###		SourceIndx, set the @ref __DoxyFunctionDeclarationNull for that function to zero, and initializes the
###		__DoxyFunctionParameterVector for that function to an empty string.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_SpecialComment_fn() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  local -r -a SourceItem=(${*})
  #
  #  We need to remember which function is the latest declared.
  #
  #  DFFB-Comment-0030 Bash "fn" directives will only translate properly when the simply name the function.
  #
  __DoxyFunctionDeclarationName=${SourceItem[1]//${__HMM_PARAM}/param}
  #
  #  The directive needs to be modified to include a return type; throw away any source data other than the name.
  #
  #  DFFB-Translate-0010 Bash "fn" directives will be augmented to include a int8_t return type.
  #
  __SourceFileLineArray[${SourceIndx}]+="${SourceItem[0]} int8_t ${__DoxyFunctionDeclarationName}"
  #
  #  The directive will later be modified to include a parameter list; keep track of its location in the source file.
  #
  __DoxyFunctionDeclarationLine[${__DoxyFunctionDeclarationName}]=${SourceIndx}
  #
  #  An "returns" directive comment will later be added nearby; track of the next unused location in the source file.
  #
  __DoxyFunctionDeclarationNull[${__DoxyFunctionDeclarationName}]=0
  #
  #  Initialize a parameter list accumulator too.
  #
  __DoxyFunctionParameterVector[${__DoxyFunctionDeclarationName}]=
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_SpecialComment_param
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent the comment portion of a source line.
###  @brief	Translates a "param" directive.
###
###  @details	The __processSourceFileLine_SpecialComment_param function updates the @ref
###		__DoxyFunctionParameterVector value for the current @ref __DoxyFunctionDeclarationName to include the
###		described parameter.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_SpecialComment_param() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  local    -a SourceItem=(${*})
  #
  local -r    ParameterName=${SourceItem[1]//${__HMM_PARAM}/param}
  #
  #  Change the directive back into something Doxygen will understand.
  #
  SourceItem[0]="@param"
  #
  #  Augment the parameter list of the current function.
  #
  #  DFFB-Translate-0020 A list of parameters whose order and name are based on the "param" directives that follow it.
  #  DFFB-Translate-0030 All function parameters in the translation will have the pseudo-type bash::string.
  #
  __DoxyFunctionParameterVector[${__DoxyFunctionDeclarationName}]+=", bash::string ${ParameterName}"
  #
  #  Translate the source code.
  #
  __SourceFileLineArray[${SourceIndx}]+=${SourceItem[*]}
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_SpecialComment
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent a source line.
###  @brief	Translates all special comment lines.
###
###  @details	The __processSourceFileLine_SpecialComment function calls other functions for handling directives of
###		interest.  All other directives are translated by removing superfluous whitespace. Comments between
###		"code" and "endcode" directives are copied without modification.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_SpecialComment() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  local -r -a SourceItem=(${*})
  #
  local       DoxygenDirective
  #
  #  Start with the special comment symbol.
  #
  local -r    SourceFileLineOriginal="${__SourceFileLineArray[${SourceIndx}]}"
  #
  #  DFFB-Comment-0010 The program will translate special comments into lines that start with "///" symbol.
  #
  __SourceFileLineArray[${SourceIndx}]="/// "
  #
  #  If the comment has substance...
  #
  if [ ${#SourceItem[*]} -gt 0 ]
  then
     #
     local       FirstSourceItem=${SourceItem[0]}
     #
     #  If this comment starts with a directive...
     #
     if [ "${FirstSourceItem:0:1}" = "@" ] || [ "${FirstSourceItem:0:1}" = "\\" ]
     then
        #
        #  Determine if it is a directive of interest.
        #
        #  Need to support "code" directive specializations like "code{.unparsed}" too.
        #
        DoxygenDirective=${FirstSourceItem:1}
        #
        case "${DoxygenDirective}" in
          ##
          code*)		DoxygenDirective=code
          ;;
          endcode|file|fn)
          ;;
          ${__HMM_PARAM})	DoxygenDirective=param
          ;;
          *)			DoxygenDirective=
          ;;
        esac
        #
        #  If the comment does not contain a directive we are interested in...
        #
        if [ ${#DoxygenDirective} -eq 0 ]
        then
           #
           #  If we are between "code" and "endcode" special comments...
           #
           if [ ${__DoxyCodeBlockActive} = ${__TRUE} ]
           then
              #
              #  Replace the Bash special-comment symbol with one for C++ code, but leave the whitespace intact.
              #
              __SourceFileLineArray[${SourceIndx}]+="${SourceFileLineOriginal/\#\#[\#\!]/}"
              #
           else
	      #
   	      #  The directive is not one we need to process further; just remove extra whitespace.
   	      #
	      #  DFFB-Comment-0020 Whitespace in special comment lines will be converted to a single blank.
	      #
   	      __SourceFileLineArray[${SourceIndx}]+=${SourceItem[*]}
   	      #
   	   fi
	   #
        else
           #
           #  If we are between "code" and "endcode" special comments and the directive is not "endcode"...
           #
           if [ ${__DoxyCodeBlockActive} = ${__TRUE} ] && [ "${DoxygenDirective}" != "endcode" ]
           then
              #
              #  Replace the Bash special-comment symbol with one for C++ code, but leave the whitespace intact.
              #
	      #  DFFB-Comment-0020 Whitespace in special comment lines will be converted to a single blank.
	      #                    except for those lines between an "code" and "endcode" directive.
	      #
              __SourceFileLineArray[${SourceIndx}]+="${SourceFileLineOriginal/\#\#[\#\!]/}"
              #
           else
   	      #
   	      #  The directive is one we want to process further; call the specialized function.
   	      #
   	      __processSourceFileLine_SpecialComment_${DoxygenDirective} ${SourceIndx} ${SourceItem[*]}
   	      #
   	   fi
   	   #
        fi
        #
     elif [ ${__DoxyCodeBlockActive} = ${__TRUE} ]
     then
        #
        #  Replace the Bash special-comment symbol with one for C++ code, but leave the whitespace intact.
        #
        __SourceFileLineArray[${SourceIndx}]+="${SourceFileLineOriginal/\#\#[\#\!]/}"
        #
     else
        #
        #  This line contains data that Doxygen can sort out; just remove extra whitespace.
        #
        __SourceFileLineArray[${SourceIndx}]+=${SourceItem[*]}
        #
     fi
     #
  fi
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_CodeOfInterest_alias
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent a source line.
###  @brief	Translates an alias statement into a string constant definition.  The alias definition is quoted, if
###		necessary.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_CodeOfInterest_alias() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  local    -a SourceItem=(${*})
  #
  local -r    AliasName=${SourceItem[1]%%=*}
  local       AliasValu=${SourceItem[1]#*=}
  #
  local    -i ValueIndx=2
  #
  while [ ${ValueIndx} -lt ${#SourceItem[*]} ]
  do
    #
    AliasValu+=" ${SourceItem[${ValueIndx}]}"
    #
    SourceItem[${ValueIndx}]=
    #
    ValueIndx+=1
    #
  done
  #
  #  Treat an alias definition as a string constant definition.
  #
  #  DFFB-Translate-0310 Alias statements will be translated to constant definitions with the public class
  #	                 access modifier and pseudo-type bash::string.
  #
  SourceItem[0]="public: const bash::string"
  #
  #  Convert the value to a string literal.
  #
  if [ "${AliasValu:0:1}" = "\"" ]
  then
     #
     SourceItem[1]="${AliasName} = ${AliasValu};"
     #
  elif [ "${AliasValu:0:1}" = "'" ]
  then
     #
     SourceItem[1]="${AliasName} = \"${AliasValu:1:$((${#AliasValu}-2))}\";"
     #
  else
     #
     SourceItem[1]="${AliasName} = \"${AliasValu}\";"
     #
  fi
  #
  #  Translate the source code.
  #
  __SourceFileLineArray[${SourceIndx}]=${SourceItem[*]}
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_CodeOfInterest_declare
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent a source line.
###  @brief	Translates an declare statement into a variable definition.
###
###  @details	The __processSourceFileLine_CodeOfInterest_declare function converts a Bash declare statement into a
###		C++ variable definition.  The type of the resulting variable is based on the options declared: -i for
###		an integer, string otherwise; -a for an array; -A for a map; -r for a constant. Variable names that
###		start with an underscore are declared private; all other are declared public. The variable value is
###		quoted, if necessary.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_CodeOfInterest_declare() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  local -r -a SourceItem=(${*})
  #
  local       BasicType="bash::string"
  #
  local       ContainerType=
  #
  local       TypeModifier=
  #
  local       VariableAccess="public"
  #
  local       VariableNameAndValue=
  #
  local    -i Index=1
  #
  while [ ${Index} -lt ${#SourceItem[*]} ]
  do
    #
    if [ ${#VariableNameAndValue} -eq 0 ]
    then
       #
       #  DFFB-Translate-0220 Bash declare statements that express the -i option will be translated using the
       #                      pseudo-type bash::integer as their base type; all others will use the pseudo-type
       #                      bash::string as their base type.
       #
       #  DFFB-Translate-0230 Bash declare statements that express the -r option will be translated into constants.
       #
       #  DFFB-Translate-0240 Bash declare statements that express the -a option will be translated using the
       #                      pseudo-type bash:array as a container of their base type.
       #
       #  DFFB-Translate-0250 Bash declare statements that express the -A option will be translated using the
       #                      pseudo-type bash:map as a container of their base type.
       #
       #  DFFB-Translate-0260 Options expressed in Bash declare statements, other than those explicitly called out in
       #                      these statements, will be ignored.
       #
       #  The "man bash" command says, "The declare, local, and readonly builtins each accept a -a option to specify an
       #  indexed array and a -A option to specify an associative array.  If both options are supplied, -A takes
       #  precedence."
       #
       case "${SourceItem[${Index}]}" in
         ##
         -A)	ContainerType="bash::map";
         ;;
         -a)	[ ${#ContainerType} -eq 0 ] && ContainerType="bash::array";
         ;;
         -i)	BasicType="bash::integer";
         ;;
         -r)	TypeModifier="const";
         ;;
         -*)	
         ;;
         *)	VariableNameAndValue="${SourceItem[${Index}]}"
         ;;
       esac
       #
    else
       #
       VariableNameAndValue+=" ${SourceItem[${Index}]}"
       #
    fi
    #
    Index+=1
    #
  done
  #
  #  Separate the name from the value.
  #
  local -r    VariableName=${VariableNameAndValue%%=*}
  local       VariableValu=${VariableNameAndValue#*=}
  #
  [ ${#VariableValu} -eq ${#VariableName} ] && VariableValu=
  #
  #  Identify private variables.
  #
  #  DFFB-Translate-0280 Constants and variables with names that begin with an underscore character will be
  #			 given a private class access modifier; all others will be given a public modifier.
  #
  if [ "${VariableName:0:1}" = "_" ]
  then
     #
     VariableAccess="private"
     #
     __HiddenObjectCount+=1
     #
  fi
  #
  #  Build a translation.
  #
  #  DFFB-Translate-0210 Bash declare statements will be translated into C++ constant and variable definitions.
  #
  local       Translation="${VariableAccess}:"
  local       TypeOfValue=${BasicType}
  #
  [ ${#TypeModifier} -gt 0 ] && Translation+=" ${TypeModifier}"
  #
  if [ ${#ContainerType} -eq 0 ]
  then
     #
     Translation+=" ${BasicType}"
     #
  else
     #
     Translation+=" ${ContainerType}<"
     #
     [ ${#TypeModifier} -gt 0 ] && Translation+=" ${TypeModifier}"
     #
     Translation+=" ${BasicType} >"
     #
     TypeOfValue="${ContainerType}<${BasicType}>"
     #
  fi
  #
  Translation+=" ${VariableName}"
  #
  #  If the value is a string then...
  #
  #  DFFB-Translate-0270 Values expressed in Bash declare statements (after an equal sign) will be preserved in
  #                      the translation, wrapped in a pseudo-type translation, and quoted if necessary.
  #
  if [ ${#VariableValu} -gt 0 ]
  then
     #
     if [ "${BasicType}" = "bash::string" ] || [ "${VariableValu:0:1}" = "'" ]
     then
        #
        #  Convert the value to a string literal.
        #
        if [ "${VariableValu:0:1}" != "\"" ]
        then
           #
           if [ "${VariableValu:0:1}" = "'" ]
           then
              #
              VariableValu="\"${VariableValu:1:$((${#VariableValu}-2))}\""
              #
           else
              #
              VariableValu="\"${VariableValu}\""
              #
           fi
           #
        fi
        #
     fi
     #
     if [ "${VariableValu:0:1}" = "(" ]
     then
        #
	Translation+=" = ${TypeOfValue}${VariableValu}"
        #
     else
        #
	Translation+=" = ${TypeOfValue}( ${VariableValu} )"
        #
     fi
     #
  fi
  #
  #  Translate the source code.
  #
  __SourceFileLineArray[${SourceIndx}]="${Translation};"
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_CodeOfInterest_endfunction
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent a source line.
###  @brief	Translates an closed curly-bracket to itself because it represents the end of a function definition.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_CodeOfInterest_endfunction() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  #
  #  Translate the source code.
  #
  #  DFFB-Translate-0110 Bash functions will be translated to empty C++ functions with class access modifiers.
  #
  __SourceFileLineArray[${SourceIndx}]="}"
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__processSourceFileLine_CodeOfInterest_function
###  @param	SourceIndx	An index into the @ref __SourceFileLineArray.
###  @param	SourceItem	An array of tokens that represent a source line.
###  @brief	Translates a Bash function definition into a C++ function definition.
###
###  @details	The __processSourceFileLine_CodeOfInterest_function function modifies several output lines so that "fn"
###		directives and function declarations can be properly translated. Function names that begin with an
###		underscore are declared private; all others are declared public. Functions are all given an int8_t
###		return type that represents a Linux exit status; a "returns" directive in a special comment s added to
###		the output at the @ref __DoxyFunctionDeclarationNull index for the named function. The @ref
###		__DoxyFunctionParameterVector parameter set is added to the associated "fn" directive by referring to
###		the @ref __DoxyFunctionDeclarationLine of the function, as wells as to the function definition profile.
###		If the Bash function is defined on one line then all Bash code is removed between the curly-brackets.
###
#----------------------------------------------------------------------------------------------------------------------

function __processSourceFileLine_CodeOfInterest_function() {
  #
  local -r -i SourceIndx=${1}
  shift 1
  local    -a SourceItem=(${*})
  #
  local -r    SpecialCommentForReturns="/// @returns A Linux exit status value (uint8_t in the range 0..255)."
  #
  local -r    FunctionName=${SourceItem[1]%%(*}
  #
  local       ParameterSet
  #
  #  Determine whether the function is public or private.
  #
  #  DFFB-Translate-0130 Functions with names that begin with an underscore will be given a private access modifier.
  #
  local       FunctionAccess=public
  #
  if [ "${FunctionName:0:1}" = "_" ]
  then
     #
     FunctionAccess=private
     #
     __HiddenObjectCount+=1
     #
  else
     #
     __PublicFunctionCount+=1
     #
  fi
  #
  #  Give the function an access and a return type.
  #
  #  DFFB-Translate-0110 Bash functions will be translated to empty C++ functions with class access modifiers.
  #  DFFB-Translate-0120 Bash function translations will be given the same return type as the "fn" directive.
  #
  SourceItem[0]="${FunctionAccess}: int8_t"
  #
  if [ "${__DoxyFunctionParameterVector[${FunctionName}]+IS_SET}" = IS_SET ]
  then
     #
     ParameterSet=${__DoxyFunctionParameterVector[${FunctionName}]}
     #
     #  DFFB-Translate-0120 Bash function translations will be given the same return type as the "fn" directive.
     #
     SourceItem[1]=${SourceItem[1]/()/(${ParameterSet:1} )}
     #
     #  DFFB-Translate-0020 Bash "fn" directives will be augmented to include a list of parameters.
     #
     __SourceFileLineArray[${__DoxyFunctionDeclarationLine[${FunctionName}]}]+="(${ParameterSet:1} )"
     #
     #  DFFB-Translate-0040 Special comment blocks that contain an "fn" directive will be given an "returns" directive.
     #
     __SourceFileLineArray[${__DoxyFunctionDeclarationNull[${FunctionName}]}]=${SpecialCommentForReturns}
     #
  fi
  #
  #  Remove any Bash code following the open-curly-bracket...
  #
  local -i    ItemIndex=3
  #
  while [ ${ItemIndex} -lt ${#SourceItem[*]} ]
  do
    #
    if [ "${SourceItem[${ItemIndex}]:0:1}" = "}" ]
    then
       #
       SourceItem[${ItemIndex}]="}"
       #
    else
       #
       SourceItem[${ItemIndex}]=
       #
    fi
    #
    ItemIndex+=1
    #
  done
  #
  #  Translate the source code.
  #
  __SourceFileLineArray[${SourceIndx}]=${SourceItem[*]}
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__doxygenFilterForBashToCxx
###  @param	InputFSpec	A Bash script file specification.
###  @brief	Translates a Bash script into a form that Doxygen can interpret as C++ code.
###
#----------------------------------------------------------------------------------------------------------------------

function __doxygenFilterForBashToCxx() {
  #
  local -r InputFSpec=${1-}
  #
  [ ${#InputFSpec} -eq 0 ] && return
  #
  local    InputLine
  #
  local -r IFSWas="${IFS}"
  #
  local -a CurrentLineToken
  #
  __DoxyFunctionDeclarationNull[${__DoxyFunctionDeclarationName}]=0
  #
  #  Read in each of the input data lines.
  #
  local -i SourceFileLineIndex=0
  #
  IFS=
     #
     while read -r InputLine
     do
       #
       #  Remove indentation as we capture every line of the input file.
       #
       __SourceFileLineArray[${SourceFileLineIndex}]="${InputLine#[ 	]*}"
       #
       SourceFileLineIndex+=1
       #
     done < ${InputFSpec}
     #
  IFS="${IFSWas}"
  #
  local    -i SourceFileLineCount=${SourceFileLineIndex}
  #
  #  For each of the lines of code in the input file...
  #
  SourceFileLineIndex=0
  #
  while [ ${SourceFileLineIndex} -lt ${SourceFileLineCount} ]
  do
    #
    CurrentLineToken=(${__SourceFileLineArray[${SourceFileLineIndex}]})
    #
    #  Determine the classification of the code line.
    #
    if [ ${#CurrentLineToken[*]} -gt 0 ]
    then
       #
       #  DFFB-Input-0010 The input Bash script may use the "###" or "##!" symbols for Doxygen special comments.
       #  DFFB-Input-0020 Doxygen special comments in the input Bash script must be on a line of their own.
       #
       if [ "${CurrentLineToken[0]}" = "###" ] || [ "${CurrentLineToken[0]}" = "##!" ]
       then
          #
          CurrentLineToken[0]=
          #
          __processSourceFileLine_SpecialComment ${SourceFileLineIndex} ${CurrentLineToken[*]//param/${__HMM_PARAM}}
          #
          #
       elif [ "${CurrentLineToken[0]:0:3}" = "###" ] || [ "${CurrentLineToken[0]:0:3}" = "##!" ]
       then
          #
          CurrentLineToken[0]=${CurrentLineToken[0]:3}
          #
          __processSourceFileLine_SpecialComment ${SourceFileLineIndex} ${CurrentLineToken[*]//param/${__HMM_PARAM}}
          #
       else
          #
          SourceFileLineClass="Insignificant"
          #
          #  Guard against source code that contains a code-endcode block without an endcode marker.
          #
          __DoxyCodeBlockActive=${__FALSE}
          #
          #  Determine whether this is a line of code we are interested in.
          #
          case "${CurrentLineToken[0]}" in
	    ##
	    alias|declare|function)	SourceFileLineClass="CodeOfInterest_${CurrentLineToken[0]}"
	    ;;
	    \}*)			SourceFileLineClass="CodeOfInterest_endfunction"
	    ;;
	    *)
	    ;;
          esac
          #
          __processSourceFileLine_${SourceFileLineClass} ${SourceFileLineIndex} ${CurrentLineToken[*]}
          #
       fi
       #
    else
       #
       __processSourceFileLine_Insignificant ${SourceFileLineIndex}
       #
    fi
    #
    SourceFileLineIndex+=1
    #
  done
  #
  #  DFFB-Translate-0420 A class wrapper will be added to the translation if the input file contained any
  #	                 insignificant lines following the special command that contains the "file" directive,
  #	                 two or more public functions were translated, and one or more private functions,
  #	                 constants, or variables were translated.
  #
  local -r InputFName=$(basename ${InputFSpec})
  #
  if [ ${__InsignificantLineAfterFileDirectiveFirst} -gt 0 ]	\
  && [ ${__InsignificantLineAfterFileDirectiveLast} -gt 0 ]	\
  && [ ${__PublicFunctionCount} -ge 1 ]				\
  && [ ${__HiddenObjectCount} -gt 0 ]
  then
     #
     __SourceFileLineArray[${__InsignificantLineAfterFileDirectiveFirst}]="class ${InputFName//./_} {"
     #
     if [ $((__InsignificantLineAfterFileDirectiveLast+1)) -eq ${SourceFileLineCount} ]
     then
        #
        __InsignificantLineAfterFileDirectiveLast=${SourceFileLineCount}
        #
        SourceFileLineCount+=1
        #
     fi
     #
     __SourceFileLineArray[${__InsignificantLineAfterFileDirectiveLast}]="}; //  ${InputFName//./_}"
     #
  fi
  #
  #  Write the translation to standard output.
  #
  SourceFileLineIndex=0
  #
  while [ ${SourceFileLineIndex} -lt ${SourceFileLineCount} ]
  do
    #
    echo "${__SourceFileLineArray[${SourceFileLineIndex}]}"
    #
    SourceFileLineIndex+=1
    #
  done
  #
}

#----------------------------------------------------------------------------------------------------------------------

__doxygenFilterForBashToCxx ${*}

#----------------------------------------------------------------------------------------------------------------------
#  (eof)
