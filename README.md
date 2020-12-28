# Permfix
A utility for recursively changing the permissions within a directory while differentiating between subdirectories and regular files.

## Project aim
On Unix-like systems, it sometimes happens that the permissions within a given directory tree will be incorrect and need to be changed.  While the `chmod` utility can operate recursively, it cannot differentiate between regular files and subdirectories, which often require different permissions.  This program allows one to change the permissions for directories and files separately throughout a directory tree of arbitraty depth.

## Dependencies
`permfix` depends on Bash, `ls`, `chmod`, and `cut`.  Bash is the GNU Bourne Again Shell, and should be present on almost all Unix-like operating systems.  `ls`, `chmod`, and `cut` are part of both the POSIX specification and the GNU Core Utilities and should likewise be present on all Unix-like operation systems.

## Installation
`permfix` is a simple shell script which may be run in place.  Nevertheless, a makefile is provided which merely copies the program to `/usr/local/bin/permfix` and sets the appropriate permissions.  Simply run `sudo make install` to install the program, and `sudo make uninstall` to remove it.

## Usage
`permfix` takes up to three arguments; only the first is required.  The first argument is the path (absolute or relative) to the file or directory to be modified.  The second and third arguments, which are optional, are the permissions to be assigned for files and directories respectively.  The default file permissions are 644 (or `-rw-r--r--`) for files and 755 (or `drwx-r-x-r-x`) for directories.  If the first argument is a regular file, `permfix` will operate identically to `chmod`, using the second argument as the permissions.

Because the second and third arguments are taken as strings, either symbolic permissions or absolute (octal) permissions may be used.  No error checking is performed on the arguments (other than that provided by `chmod` itself), so users should take care that the arguments are valid permission modes.

`permfix` will issue a stern warning and ask for confirmation if run with root privileges, and will fail to operate entirely if given certain sensitive system directories as an argument (notably `/`, `/bin`, and other high-level directories).  As `permfix` is a recursive permissions modifying program, the potential for irreperable system damage is high. Users should take care that they do not call the program on any sensitive directories, and that they know what the worst possible damage to their system could be based on the directory they feed to it.  `permfix` is not designed to be, nor should it be used as, a comprehensive permissions manager for one's system.  It is intended mainly for use on unpacked archives or downloaded files on which incorrect permissions may have been set, or on user directories after a change to the system umask.

## Contribution
Bugfixes and improvements are very much welcome.  Some ideas include:

* Optimizing the program to run faster (possible including a rewrite in a different language)
* Allowing `permfix` to differentiate between different types of files
* Improving the command syntax with options and parameters rather than fixed-order arguments

## License and Copyright
`permfix` is Copyright (C) 2020 Eric Edstrom

`permfix` is licensed under the GNU General Public License version 3, or any later version.  For full details please see the LICENSE.md file.
