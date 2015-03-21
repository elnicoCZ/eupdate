#!/bin/sh

input="$1";
output="$2";

cat $input |\
sed 's/ě/e/g' |\
sed 's/š/s/g' |\
sed 's/č/c/g' |\
sed 's/ď/d/g' |\
sed 's/é/e/g' |\
sed 's/ř/r/g' |\
sed 's/ž/z/g' |\
sed 's/ý/y/g' |\
sed 's/á/a/g' |\
sed 's/í/i/g' |\
sed 's/ď/d/g' |\
sed 's/ň/n/g' |\
sed 's/ť/t/g' |\
sed 's/ó/o/g' |\
sed 's/ů/u/g' |\
sed 's/ú/u/g' |\
sed 's/Ě/E/g' |\
sed 's/Š/S/g' |\
sed 's/Č/C/g' |\
sed 's/Ď/D/g' |\
sed 's/É/E/g' |\
sed 's/Ř/R/g' |\
sed 's/Ž/Z/g' |\
sed 's/Ý/Y/g' |\
sed 's/Á/A/g' |\
sed 's/Í/I/g' |\
sed 's/Ď/D/g' |\
sed 's/Ň/N/g' |\
sed 's/Ť/T/g' |\
sed 's/Ó/O/g' |\
sed 's/Ů/U/g' |\
sed 's/Ú/U/g' > $output

