#
#  .kamaji.sed
#

s,%HOME%/[^[:space:]]*/\(HolmespunLibraryBashing\),\$\1,g
s,/opt/[^[:space:]]*/\(HolmespunLibraryBashing\),\$\1,g

#  ../Library/sourceWithCare.bash: line 128: hash: whereZolmespunLibraryBashing: not found

s,line [0-9][0-9]*:,line LINENO:,g

# SOURCE.20211201_090441

s,\.[0-9]\{8\}_[0-9]\{6\},.YYYYMMDD_HHMMSS,g

#
