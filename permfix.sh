#!/usr/bin/env bash
#
#   permfix Copyright (C) 2020 Eric Edstrom
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

dirfix () {
	for i in $(ls $1)
	do
		if [ "$(ls -ld $1/$i | cut -c-1 -)" == '-' ]
		then
			chmod --preserve-root $fperm $1/$i
		fi
		if [ "$(ls -ld $1/$i | cut -c-1 -)" != '-' ] && [ "$(ls -ld $1/$i | cut -c-1 -)" != 'd' ]
		then
			1>&2 echo "Warning: $i has an unsupported file type"
		fi
		if [ "$(ls -ld $1/$i | cut -c-1 -)" != 'd' ]
		then
			continue
		fi
		(
		cd $1
		if [ "$(ls -ld $i | cut -c-1 -)" == '-' ]
		then
			chmod --preserve-root $fperm $i
		elif [ "$(ls -ld $i | cut -c-1 -)" == 'd' ]
		then
			chmod --preserve-root $dperm $i
			(
			cd $i
			for j in $(ls -d)
			do
				dirfix $j
			done
		)
		else
			1>&2 echo "Warning: $i has an unsupported file type"
		fi
	)
	done
	}
for i in $(echo /*)
do
	if [ "$1" == $i ]
	then
		echo "WARNING: You have attempted to use permfix on a sensitive system directory.  This is not permitted as it can (and probably will) render your system unusable."
		exit 0
	fi
done
if [ "$1" == '/' ]
then
		echo "WARNING: You have attempted to use permfix on a sensitive system directory.  This is not permitted as it can (and probably will) render your system unusable."
		exit 0
fi
if [ "$EUID" == '0' ] || [ "$UID" == '0' ] || {"$(whoami)" == 'root' ]
then
	echo "WARNING: You are currently running as root."
	echo -e "\nRunning permfix as root is highly discouraged as it could IRREPARABLY damage your system."
	echo "Please ensure that the file or directory you are attempting to modify is not critical to your system in any way."
	echo "If you are confused by this warning or unsure of what the target directory does, DO NOT PROCEED."
	echo -e "\nIf you are sure you wish to continue, type 'YES' at the prompt below.  Otherwise, type any other characters to abort."
	echo -en "\nAre you sure you wish to proceed? "
	read confirm
	if [ "$confirm" != 'YES' ]
	then
		exit 0
	fi
fi
fperm=644
dperm=755
if [ -n "$2" ]
then
	fperm=$2
fi
if [ -n "$3" ]
then
	dperm=$3
fi
if [ "$(ls -ld $1 | cut -c-1 -)" == '-' ]
then
	chmod --preserve-root $fperm $1
elif [ "$(ls -ld $1 | cut -c-1 -)" == 'd' ]
then
	chmod --preserve-root $dperm $1
	dirfix $1
else
	1>&2 echo "Error: unsupported file type"
fi
