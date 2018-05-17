#!/bin/bash

## SETTINGS
# paths
 rdir=$1
 ofil="RELEASES"
# dates
 idate="20030601 010000" 	# Initialization
 sdate="20030601 020000"	# Start of boundary release
 edate="20030602 000000"	# End of boundary release
# number of particles
 npb=1540			# boundary particles; multiply with hours
 npi=35				# initilization particles; release only once

## ADJUST RELEASE template
 rtmp="../templates/RELEASES_sponge_template"
 cp $rtmp $rdir/$ofil
 
 sed -i -e "s/__NPINI__/${npi}/g" $rdir/$ofil
 sed -i -e "s/__IDATESTART__/${idate}/g" $rdir/$ofil
 sed -i -e "s/__BDATESTART__/${sdate}/g" $rdir/$ofil
 sed -i -e "s/__BDATEEND__/${edate}/g" $rdir/$ofil
 sed -i -e "s/__NPBOUND__/${npb}/g" $rdir/$ofil

 echo "Succesfully created: $rdir/$ofil"

exit
