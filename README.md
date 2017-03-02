# EUPDATE: Elnico Updater

Bash tool allowing to do simple updates of Linux file system by adding, removing and replacing individual files, contained in an *.epd* package.

It consists of three tools:
  * **ediff**: Produces the *.epd* package out of two *.tar.bz2* archives.
  * **edistro**: Produces the *.epd* package from an input tree.
  * **eupdate**: Installs the *.epd* package.

## How to Prepare an *.epd* File

### ediff

Having two images of Linux filesystems, *orig.tar.bz2* and *new.tar.bz2* (such as outputs of the Yocto project build), one can use the **ediff** tool to generate the update package, containing only the changed files: `./ediff orig.tar.bz2 new.tar.bz2`. Anyway, since Yocto changes far more binaries than whose source files actually changed, this tool is **experimental** and is not recommended to be used with Yocto.

### edistro

Lets have a target file system tree, like the one in *test/root/*. Now we want to add, overwrite and remove some files to that target tree. Prepare a *eupdate/* directory inside your working tree, like the *test/eupdate/*. That directory should contain all files that should be written, organized in the required directory tree. To remove some files, create a dummy (possibly empty) file, having the name of the file to be removed, with an additional *.eremove* extension. When the tree is prepared, add an additional *manifest* file, defining the version of this update and a list of versions, on which this update can be applied. Check the current *manifest* file on your target file system (e.g. *test/root/etc/eupdate/config/manifest*) to ensure the new *manifest*'s **EUPDATE_APPLICABLE_FOR** list contains the current *manifest*'s **EUPDATE_VERSION** value.

Now execute the **edistro** utility to produce the *.epd* package: `./edistro test/`. Note the *test/* is a working directory, which *must* contain the *eupdate/* input tree. Also note the *root/* directory does *not* need to be present in the working directory, the **edistro** tool does not touch it. The resulting *eupdate.epd* file is located in the provided working directory (i.e. *test/*).

The *.epd* package is actually just a *.tgz* archive. To examine its contents, one should typically need just to change the extension.

## How to Install an *.epd* File

To install the update file, the target file system has to feature the **eupdate** tool. This is usually located in */etc/eupdate/* directory, like in our testing tree (*test/root/etc/eupdate/*). That directory must further contain the *config/* directory, containing the *manifest* and *config* files.
Having an *.epd* file, just execute `./eupdate PATH/TO/eupdate.epd`.

Here is our testing example:
  `cd test/root/etc/eupdate/`
  `./eupdate ../../../eupdate.epd`

Eupdate makes a backup of the last set of changes and creates a **erevert** script. To revert the last update, just execute `./erevert`.
