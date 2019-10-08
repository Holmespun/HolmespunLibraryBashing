#----------------------------------------------------------------------------------------------------------------------
#
#  Testing/generateMarkdownTocLinksFor_exercise.bash
#
#  20180312 BGH; created.
#
#----------------------------------------------------------------------------------------------------------------------

set -u

#----------------------------------------------------------------------------------------------------------------------

echo "# generateMarkdownTocLinksFor_exercise.bash"
echo ""

generateMarkdownTocLinksFor generateMarkdownTocLinksFor_exercise.input.md

echo ""

cat generateMarkdownTocLinksFor_exercise.input.md

echo ""
echo "**(eof)**"

#----------------------------------------------------------------------------------------------------------------------
