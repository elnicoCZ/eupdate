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
workdir=$(pwd)
source=$workdir/test/eupdate/
dest=$workdir/test/root/

version_old=18
version_new=19

cd $source
tree="$(find)"

echo -e "Updating from $version_old to $version_new"

# Obtains a list of all directories in source.
for file in $tree; do
  if test -d $source/$file
  then
    #echo "$file"
    dirs="$dirs $file"
  fi
done

# Obtains a list of all files in source.
for file in $tree; do
  if test -f $source/$file
  then
    #echo -e "$file"
    files="$files $file"
  fi
done

# Creates a backup file for every file in dest which is to be overwritten.
# The backup filename is: "filename.version"
for file in $files; do
  if test -f $dest/$file
  then
    echo -e "Making a backup for $dest/$file"
    cp $dest/$file $dest/$file.$version_old
  fi
done

# Creates directories which exist in source but not in dest.
for file in $dirs; do
  if ! test -d $dest/$file
  then
    echo -e "Creating new directory $dest/$file"
    mkdir $dest/$file
  fi
done

# Copies all files from source to dest.
for file in $files; do
  echo -e "Copying $dest/$file"
  cp $source/$file $dest/$file
done