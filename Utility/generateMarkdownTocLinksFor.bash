#----------------------------------------------------------------------------------------------------------------------
###
###			generateMarkdownTocLinksFor.bash
###
###	@file
###	@author		Brian G. Holmes
###	@copyright	GNU General Public License
###	@brief		Given a markdown file specification and (optional) starting header level, generate markdown
###			links for the headers in the file.
###	@remark		Usage: generateMarkdownTocLinksFor.bash <md-fspec> [ <header-level> ]
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
#  20180310 BGH; created.
#  20180513 BGH; slash and period characters are translated to dash characters.
#  20190929 BGH; moved to HLB repo.
#
#----------------------------------------------------------------------------------------------------------------------

set -u

#----------------------------------------------------------------------------------------------------------------------
###
###  @var	__BashLibraryDSpec
###  @brief	The location of the Bash library functions.
###
#----------------------------------------------------------------------------------------------------------------------

declare -r __BashLibraryDSpec=$(whereHolmespunLibraryBashing)/Library

source ${__BashLibraryDSpec}/echoDatStampedFSpec.bash

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__echoMarkdownLinkForHeader
###  @param	Header	The header for which a link must be generated.
###  @brief	Create a markdown link for the given header.
###  @details	This function is based on
###  		https://stackoverflow.com/questions/6695439/how-to-link-to-a-named-anchor-in-multimarkdown
###
###			"I test Github Flavored Markdown for a while and summary 4 rules:
###
###				1. punctuation marks will be dropped
###				2. leading white spaces will be dropped
###				3. upper case will be converted to lower
###				4. spaces between letters will be converted to -"
###
###		This recipe has been found to be inaccurate w.r.t. how punctuation is handled.
###
#----------------------------------------------------------------------------------------------------------------------

function __echoMarkdownLinkForHeader() {
  #
  local Header="${*}"
  local Result="${Header}"
  #
  #  1. punctuation marks will be dropped
  #
  Result=$(echo "${Result}" | tr --delete --complement '[:alnum:] ./_-')
  #
  #  2. leading white spaces will be dropped
  #
  while [ ${#Result} -gt 0 ] && [ "${Result:0:1}" = " " ]; do Result="${Result:1}"; done
  #
  #  3. upper case will be converted to lower
  #
  Result="${Result,,}"
  #
  #  4. spaces between letters will be converted to -"
  #
  Result="${Result//[ \.\/]/-}"
  #
  #  Place the result in markdown link format.
  #
  echo "[${Header}](#${Result})"
  #
}

#----------------------------------------------------------------------------------------------------------------------
###
###  @fn	__generateMarkdownTocLinksFor
###  @param	InputFSpec	The specification of a markdown file.
###  @param	LevelStart	[optional] The header level at which the TOC item,s should begin.
###  @brief	Generates Table-Of-Content (TOC) links based on the headers in the input markdown file.
###
#----------------------------------------------------------------------------------------------------------------------

function __generateMarkdownTocLinksFor() {
  #
  local InputFSpec=${1-}
  local LevelStart=${2-2}
  #
  if [ ${#InputFSpec} -eq 0 ] || [ ! -e ${InputFSpec} ]
  then
     #
     echo "ERROR: Must provide an input markdown file."
     #
     return 1
     #
  fi
  #
  local -r TemporaryFSpec=$(echoDatStampedFSpec ./${FUNCNAME}.$$.)
  #
  grep "^#" ${InputFSpec} > ${TemporaryFSpec}
  #
  local    HeaderMark HeaderName
  #
  local -i HeaderIndxNow=0
  local -i HeaderIndxWas=0
  #
  local    TocTextualNow=
  local    TocTextualWas=
  #
  local    TocTextualPrefix=">\n"
  #
  local -i TocLevel=0
  #
  local -a TocLinkage
  #
  while read HeaderMark HeaderName
  do
    #
    HeaderIndxNow=${#HeaderMark}
    #
    TocLinkage[${HeaderIndxNow}]="$(__echoMarkdownLinkForHeader ${HeaderName})"
    #
    TocLevel=${LevelStart}
    #
    TocTextualNow=
    #
    while [ ${TocLevel} -le ${HeaderIndxNow} ]
    do
      #
      TocTextualNow+="${TocTextualPrefix}${TocLinkage[${TocLevel}]}"
      #
      TocLevel+=1
      #
    done
    #
    if [ ${#TocTextualWas} -gt 0 ] && [ ${HeaderIndxWas} -ge ${HeaderIndxNow} ]
    then
       #
       echo -n "* "
       #
       echo -e "${TocTextualWas:${#TocTextualPrefix}}"
       #
    fi
    #
    HeaderIndxWas=${HeaderIndxNow}
    #
    TocTextualWas="${TocTextualNow}"
    #
  done < ${TemporaryFSpec}
  #
  rm     ${TemporaryFSpec}
  #
  if [ ${#TocTextualWas} -gt 0 ]
  then
     #
     echo -n "* "
     #
     echo -e "${TocTextualWas:${#TocTextualPrefix}}"
     #
  fi
  #
}

#----------------------------------------------------------------------------------------------------------------------

__generateMarkdownTocLinksFor ${*}

#----------------------------------------------------------------------------------------------------------------------
