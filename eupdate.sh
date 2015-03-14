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
################################################################################

#!/bin/sh

################################################################################
# Init

clear;

# Destination folder
workdir=$(pwd)
tgz="$1"

tmp=$workdir/tmp/
config=$workdir/config/
source=$tmp/eupdate/
dest=$workdir/test/root/

manifest=manifest
uninstall=$workdir/uninstall

backup=$workdir/backup/

################################################################################
# Functions

function quit {
  # Performs clenaup and quits
  if test -d $tmp; then
    rm -r $tmp
  fi
  exit
}

################################################################################
# Tar extract

if test -e $tmp/*; then                                                         # Remove all possible content of the temp directory
  rm -r $tmp/*
fi

if ! test -d $tmp; then                                                         # Create a temp directory if not exist
  mkdir $tmp
fi

tar -xzf $tgz -C $tmp                                                           # Extract update to tmp

################################################################################
# Version check

. $config/$manifest                                                             # Reads the installed version from the manifest file
version_installed=$EUPDATE_VERSION

. $source/$manifest                                                             # Reads the update version from the update manifest file
version_new=$EUPDATE_VERSION
updatable_version=$EUPDATE_APPLICABLE_FOR

updatable=0                                                                     # Searches if update could be applied to the currently installed version
for version in $updatable_version; do
  if [ "$version" == "$version_installed" ]; then
    updatable=1
    break
  fi
done

if [ "$updatable" -eq 0 ]; then                                                 # Exit if update not possible
  echo "Update from version $version_installed to version $version_new not possible."
  quit
fi

echo "Updating from version $version_installed to version $version_new"
cp $config/$manifest $config/$manifest.prev                                     # Overwrites the manifest file
cp $source/$manifest $config/$manifest
rm $source/$manifest

echo "rm $uninstall" > $uninstall
if test -f $config/$manifest.prev; then
  sed -i "1irm $config/$manifest.prev" $uninstall
  sed -i "1icp $config/$manifest.prev $config/$manifest" $uninstall
fi

chmod +x $uninstall

################################################################################
# Obtains a list of all directories and files in source dir

cd $source
tree="$(find)"

for file in $tree; do                                                           # Dirs
  if test -d $source/$file; then
    dirs="$dirs $file"
  fi
done

for file in $tree; do                                                           # Files
  if test -f $source/$file; then
    files="$files $file"
  fi
done

################################################################################
# Backup

sed -i "1irmdir $backup" $uninstall                                             # Create the backup directory
if ! test -d $backup; then
  mkdir $backup
fi

for file in $dirs; do                                                           # Creates directories which exist in source but not in backup.
  if ! test -d $backup/$file; then
    echo -e "Creating backup directory $backup/$file"
    
    sed -i "1irmdir $backup/$file" $uninstall
    mkdir $backup/$file
  fi
done

for file in $files; do                                                          # Creates a backup file for every file in dest which is to be overwritten.
  if test -f $dest/$file; then
    echo -e "Making a backup for $dest/$file"
    
    sed -i "1irm ${backup}/${file}" $uninstall
    sed -i "1icp ${backup}/${file} ${dest}/${file}" $uninstall
    cp $dest/$file $backup/$file
  fi
done

################################################################################
# Deploy

for file in $dirs; do                                                           # Creates directories which exist in source but not in dest.
  if ! test -d $dest/$file; then
    echo -e "Creating new directory $dest/$file"
    
    sed -i "1irmdir $dest/$file" $uninstall
    mkdir $dest/$file
  fi
done

for file in $files; do                                                          # Copies all files from source to dest.
  echo -e "Copying $dest/$file"
  
  sed -i "1irm $dest/$file" $uninstall
  cp -a $source/$file $dest/$file
done

sed -i "1i#!/bin/sh" $uninstall

################################################################################
# Cleanup and quit

quit
