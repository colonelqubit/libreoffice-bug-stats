#!/bin/bash

# LibreOffice QA
#
# Pull script for some stats and...stuff?
#
#
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
# Copyright (c) 2013 - Joel Madero

# 2013 - Robinson - Refactored, improved, etc..
# 2012 - Joel     - Created
#

echo "Time to make the doughnuts!"
echo ""

#basepath="/data/Joel_Documents/Work/Non-Profit/Libre-Office/"
basepath=~/scratch/fdo-stats

# Download script/action
#action="echo wget"   # Use this action for a "Dry Run" of the system
action="wget"

# We need some date stuff
thisYear=$(date +"%Y")
now=$(date +"%Y_%m_%d")


# We do the same thing twice. We do the same thing twice.
# Function time!  (P.S. Bash functions have some nuances...)

# PartyHat()
# This function expects 3 arguments.
PartyHat ()
{
    echo ""
    echo "--- Starting our Party ---"
    echo ""

    # Behold, our gallant directories...
    BugDir=$1
    RawData=$1/RawData
    PerDay=$1/PerDay

    echo "BugDir: '$BugDir'"
    echo "RawData: '$RawData'"
    echo "PerDay: '$PerDay'"

    # The URL from which we pull some delicious data.
    Url=$2
    echo "Url: '$Url'"

    # The year from which we start...
    StartYear=$3
    echo "StartYear: '$StartYear'"

    # If they do not yet exist, spirit them into existence..
    mkdir -p $BugDir $RawData $PerDay

    cd $BugDir

    echo "-----"

    for(( pullYear=$StartYear; pullYear<=$thisYear; pullYear++ ))
    do
	outfile=$now" - $pullYear".csv
	#echo $Url
	UrlFormatted=${Url//PULLYEAR/$pullYear}
	#echo "==>" $UrlFormatted

	echo "Data -> outfile: '$outfile'"
	$action "$UrlFormatted" -O "$outfile"

	if [ -f "$outfile" ]
	then
	    mv "$outfile" $RawData
	else
	    echo "==> Shit, where is the outfile '$outfile'?"
	    exit 1
	fi
    done

    echo "-----"

    # Travel to the mysterious Raw Data directory
    echo "Time to deal with the Raw Data: '$RawData'"
    cd $RawData
    
    files=$now*.csv

    if ls $files &> /dev/null
    then
        # Make sure that there's a newline at the end of each file
        # when we concatenate them.
	for f in $files; do sed -e '$a\' "$f"; done > $PerDay/$now.csv
	
	echo "Files matching '$now' shoved into PerDay directory '$PerDay'"
    else
	echo "The 'now' files are missing..."
	exit 1
    fi

    echo "The party is over."
    echo ""
}

# First part
FDO=$basepath/FDOBugs2
URL="https://bugs.freedesktop.org/buglist.cgi?bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_status=RESOLVED&bug_status=VERIFIED&bug_status=CLOSED&bug_status=NEEDINFO&bug_status=PLEASETEST&chfield=%5BBug%20creation%5D&chfieldfrom=PULLYEAR-01-01&chfieldto=PULLYEAR-12-31&columnlist=product%2Ccomponent%2Cassigned_to%2Cbug_status%2Cresolution%2Cshort_desc%2Cchangeddate%2Calias%2Cassigned_to_realname%2Cbug_id%2Cflagtypes.name%2Crep_platform%2Ckeywords%2Clongdescs.count%2Copendate%2Cop_sys%2Cpriority%2Cqa_contact%2Cqa_contact_realname%2Creporter%2Creporter_realname%2Cbug_severity%2Cshort_short_desc%2Cbug_file_loc%2Cversion%2Cvotes%2Cstatus_whiteboard&limit=0&list_id=208493&product=LibreOffice&query_format=advanced&ctype=csv&human=1"

PartyHat $FDO $URL 2010

# Part Le Second...
AOO=$basepath/AOOBugs2
URL="https://issues.apache.org/ooo/buglist.cgi?bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=ACCEPTED&bug_status=REOPENED&bug_status=RESOLVED&bug_status=VERIFIED&bug_status=CLOSED&chfieldfrom=PULLYEAR-01-01&chfieldto=PULLYEAR-12-31&query_format=advanced&resolution=---&ctype=csv&human=1"

PartyHat $AOO $URL 2004

# Adios..
echo "Script done. Time for fun."
