#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
#
#  echoRelativePath_exercise.bash
#
#----------------------------------------------------------------------------------------------------------------------

set -u

source ../Library/echoRelativePath.bash

function echoAndCall() { echo "${*}	: $(eval ${*})"; }
 
echo "echoRelativePath_exercise..."
echo "============================"

echoAndCall echoRelativePath . .
echoAndCall echoRelativePath .. ..
echoAndCall echoRelativePath .. .
echoAndCall echoRelativePath . ..
echoAndCall echoRelativePath ../../alpha ../../beta
echoAndCall echoRelativePath ../../../ ./alpha/beta////
echoAndCall echoRelativePath ./alpha/beta ../../../
echoAndCall echoRelativePath ./alpha/../beta/./.././gamma/delta/epsilon/ .

echo "============================"

#----------------------------------------------------------------------------------------------------------------------
