#!/bin/bash

ipath=$1

#cp AVAILABLE_header AVAILABLE
echo "DATE     TIME        FILENAME      SPECIFICATIONS" > AVAILABLE
echo "YYYYMMDD HHMISS				       " >> AVAILABLE
echo "-------- ------      ----------    ------------- " >> AVAILABLE

for ifile in $1/cclm*.nc; do
	iifile=$(basename $ifile)
	echo $iifile
	yyyy=${iifile:4:4}
	mm=${iifile:8:2}
	dd=${iifile:10:2}
	hh=${iifile:12:2}
        echo "${yyyy}${mm}${dd} ${hh}0000      $iifile" >> AVAILABLE
done

