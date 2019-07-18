#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
#
#  echoInColor_exercise.bash
#
#----------------------------------------------------------------------------------------------------------------------

set -u

source ../Library/echoInColor.bash

function echoAndCall() { echo "${*}	yields $(eval ${*})"; }
 
echo "echoInColor_exercise..."
echo "======================="

for Color in Blue Green Red RedBold White WhiteBold Yellow
do
  #
  echoInColor${Color} "echoInColor${Color}"
  #
done

echo "======================="

#----------------------------------------------------------------------------------------------------------------------
