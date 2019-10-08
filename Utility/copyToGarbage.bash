#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
###
###			copyToGarbage.bash
###
###	@file
###	@author		Brian G. Holmes
###	@copyright	GNU General Public License
###	@brief		Copies each file in a list of files into the garbage directory.
###	@remark		Usage: copyToGarbage.bash <file-specification>...
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
#  20190929 BGH; moved to HLB repo.
#
#----------------------------------------------------------------------------------------------------------------------

set -u

source $(whereHolmespunLibraryBashing)/Library/copyToGarbage_and_moveToGarbage.bash

#----------------------------------------------------------------------------------------------------------------------

copyToGarbage ${*}

#----------------------------------------------------------------------------------------------------------------------
