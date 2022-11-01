#----------------------------------------------------------------------------------------------------------------------
#
#  HolmespunLibraryBashing/makefile
#
#	Supports testing and installation of the items in the HolmespunLibraryBashing repository.
#
#  20190907 BGH; created.
#
#----------------------------------------------------------------------------------------------------------------------

QUIET		?= @
#QUIET		?= 

KamajiFSpec	?= $(shell which kamaji)

#----------------------------------------------------------------------------------------------------------------------

.PHONY :	install test

#----------------------------------------------------------------------------------------------------------------------

spellcheck :
	@echo "make $@"
	$(QUIET) wordsNotKnown	COPYING.text README.md makefile		\
				$(shell find Documen/ -type f) 		\
				$(shell find Library/ -type f) 		\
				$(shell find Support/ -type f) 		\
				$(shell find Testing/ -type f) 		\
				$(shell find Utility/ -type f) 		

#----------------------------------------------------------------------------------------------------------------------

test :
	@echo "make $@"
	$(QUIET) $(KamajiFSpec) grade

#----------------------------------------------------------------------------------------------------------------------

install :
	@echo "make $@"
	$(QUIET) Support/INSTALL.bash

#----------------------------------------------------------------------------------------------------------------------
#  (eof)
