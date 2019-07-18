#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
#
#  echoRelativePath_exercise.bash
#
#----------------------------------------------------------------------------------------------------------------------

set -u

source ../Library/echoRelativePath.bash

function echoAndCall() { echo "${*}	yields $(eval ${*})"; }
 
echo "echoRelativePath_exercise..."
echo "============================"

echoAndCall echoRelativePath . .

echo "----------------------------"

echoAndCall echoRelativePath .. ..

echo "----------------------------"

echoAndCall echoRelativePath .. .

echo "----------------------------"

echoAndCall echoRelativePath . ..

echo "----------------------------"

echoAndCall echoRelativePath ../../alpha ../../beta

echo "----------------------------"

echoAndCall echoRelativePath ../../../ ./alpha/beta////

echo "----------------------------"

echoAndCall echoRelativePath ./alpha/beta ../../../

echo "----------------------------"

echoAndCall echoRelativePath ./alpha/../beta/./.././gamma/delta/epsilon/ .

echo "============================"

#----------------------------------------------------------------------------------------------------------------------
