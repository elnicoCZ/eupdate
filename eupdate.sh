###############################################################################
#
#  @file       eupdate.sh
#  @brief      ...
#
#  ...
#
#  @copyright  Elnico Ltd. All rights reserved.
#  @author     Jan Kubiznak <kubiznak.jan@elnico.cz>
#
#  @version    1.0 2015-03-08: Jan Kubiznak <kubiznak.jan@elnico.cz>
#                              Initial revision.
#
###############################################################################

#!/bin/sh

###############################################################################
# Script init and start tests

clear;

# Destination folder
source=./test/eupdate/
dest=./test/root/
tooldir=../../

version_old=18
version_new=19

cd $source
tree="$(find)"

echo -e "============================================"
echo -e "Version information"
echo -e "============================================"

echo -e "Previously installed version: $version_old"
echo -e "Newly installed version: $version_new\n"


echo "============================================"
echo "Content of eupdate"
echo "============================================"

echo "Directories:"

for file in $tree; do
  if test -d $file
  then
    echo "$file"
    dirs="$dirs $file"
  fi
done

echo -e "\nFiles:"

for file in $tree; do
  if test -f $file
  then
    echo -e "$file"
    files="$files $file"
  fi
done

echo -e "============================================"
echo -e "Update"
echo -e "============================================"

cd $tooldir/$dest

for file in $files; do
  if test -f $file
  then
    echo -e "Backing up $dest/$file to $dest/$file.$version_old"
    cp $file $file.$version_old
  fi
done

for file in $dirs; do
  if ! test -d $file
  then
    echo -e "Creating new directory $dest/$file"
    mkdir $file
  fi
done

cd $tooldir

for file in $files; do
  echo -e "Copying $source/$file to $dest/$file"
  cp $source/$file $dest/$file
done