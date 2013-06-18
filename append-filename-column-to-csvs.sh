#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http:www.gnu.org/licenses/>.
#
# Copyright (c) 2013 - Robinson Tryon <qubit@runcibility.com>
#
#
# For each CSV file in the working directory, add the filename as a
# new column in each CSV file.
#
# - Assumes TAB-delimited files
#
# Example:
#   2012-04-01.csv
#       Foo    Bar   Baz
#       Bling  Bla   Bloop
# Becomes:
#   2012-04-01.csv
#       Foo    Bar   Baz   2012-04-01.csv
#       Bling  Bla   Bloop 2012-04-01.csv

echo "Searching for CSV files and such..."

files=`ls -1 *.csv`

for f in $files
do
    echo "File is: '$f'"
    last_column=`head -n1 $f |awk -F"\t" '{print $NF}'`
    echo "--> Last column is: '$last_column'"

    # Only append the filename column if it isn't already in place.
    if [ "$last_column" = "$f" ]
    then
	echo "--> WARNING: Last column matches filename. Append(ectomy) aborted."
    else
	echo "--> Appending filename as column to file: '$f'"
	sed -e 's/$/\t'$f'/' -i $f
    fi
done

echo ""
echo "Le Party Endeth: Done with CSV files"
