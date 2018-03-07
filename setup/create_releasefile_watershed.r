rm(list=ls())
# Script to create a RELEASE file for a single watershed
# 
# Each gridpoint from the waterhsed is identified as a RELEASE point. 
# 
# Options: 
# Rscript create_releasefile_watershed.r WS np dstart dend rundir
#  - WS: 	watershed name ("Guadalquivir")
#  - np: 	number of particles to be released at each grid point 
#  - dstart: 	startdate of RELEASE
#  - dend: 	enddate of RELEASE
#  - rundir:	run-directory, where RELEASE file should be written
#
# Example: 
# Rscript create_releasefile_watershed.r "Guadalquivir" 100 "20030101 100000" "20030101 100000" /user/data/gent/gvo000/gvo00090/vsc42383/flexpart/flexpart_cosmo/test_jke20 
# JKe 06-03-2018

library(ncdf4)
library(maptools)

# watersheds
        worldmaps = readShapeSpatial("/user/data/gent/gvo000/gvo00090/vsc42383/data/terrsysmp/staticdata/TM_WORLD_BORDERS-0.2.shp")
        mybasins=readRDS("/user/data/gent/gvo000/gvo00090/vsc42383/data/terrsysmp/staticdata/mywatersheds_eur11_gt100km2.rds")
        basinnames=readRDS("/user/data/gent/gvo000/gvo00090/vsc42383/data/terrsysmp/staticdata/mywatershednames_eur11_gt100km2.rds")
	basinnames[2247]="Guadalquivir"
	basinnames[2183]="Guadiana"
	basinnames[1693]="Ebro"
	basinnames[1565]="Douro"
	basinnames[1006]="Garonne"
	basinnames[1229]="Rhone"
	basinnames[651]="Seine"
	basinnames[721]="Loire"
	basinnames[1002]="Dordongne"
	basinnames[1938]="Jucar"
	basinnames[1958]="Tagus"
	basinnames[2059]="Segura"
	basinnames[1010]="Po"
	basinnames[1469]="Tiber"
	basinnames[980]="Danube"
	basinnames[538]="Rhine"
	basinnames[457]="Weser"
	basinnames[435]="Elbe"
	basinnames[437]="Oder"
	supp_names=basinnames[which(!is.na(basinnames))]	

cat("Supported watersheds: ", supp_names, "\n")
# read command line options
args 	= commandArgs(TRUE)
stopifnot(length(args) == 5)
ws   	= args[1]
np   	= as.double(args[2])
dstart	= args[3]
dend	= args[4]
rundir	= args[5] 

## SETTINGS
# paths
        ipath="/user/data/gent/gvo000/gvo00090/vsc42383/tools/flexpart/pre-processing"
	setwd(ipath)
# grid
        gridfile=nc_open("/user/data/gent/gvo000/gvo00090/vsc42383/data/terrsysmp/staticdata/focus_mask_eur11_315x315.nc")
        lon=ncvar_get(gridfile,"lon")
        lat=ncvar_get(gridfile,"lat")
# mask
        maskfile= nc_open("/user/data/gent/gvo000/gvo00090/vsc42383/data/terrsysmp/staticdata/focus_mask_eur11_315x315.nc")
        mask    = ncvar_get(maskfile,"LANDMASK")
	lindi	= which(mask==1)
	mlon	= lon[lindi]
	mlat	= lat[lindi]
# spatial points with landmask==1
	gcoord=SpatialPoints(data.frame(lon=c(lon[lindi]),lat=c(lat[lindi])), proj4string=CRS(as.character(NA)), bbox = NULL)
        proj4string(gcoord)              <- "+proj=longlat +datum=WGS84"

# Sample grid coordinates over watershed
	wind	= which(basinnames==ws)
	mydatf	= over(gcoord,mybasins[wind,])
	mydatf2	= mydatf[which(!is.na(mydatf[,1])),]
	slon	= mlon[as.numeric(rownames(mydatf2[,]))]
	slat	= mlat[as.numeric(rownames(mydatf2[,]))]
	lmask	= mask[lindi]
	smask   = lmask[as.numeric(rownames(mydatf2[,]))]

# OUTPUT
# a) text file with grid points
	ofile	= sprintf("%s/wspoints/gridpoints_in_%s.txt",ipath,ws)
	write.table(cbind(round(slon,digits=4),round(slat,digits=4)),file=ofile,row.names=FALSE,col.names=FALSE)

# OUTPUT 
# b) RELEASE FILE
	ilon	= round(slon,digits=4)
	ilat	= round(slat,digits=4)
	mag	= 1
	lzl	= 0.0
	uzl 	= 10000.0
	tme	= 1.0 #1.0000E06
	sep	= "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

	alld=NULL
	for(i in 1:length(slon)){
	  alld	= c(alld,c(dstart,dend,ilon[i],ilat[i],ilon[i],ilat[i],mag,lzl,uzl,np,tme,i,sep))
	}
	system(sprintf("cp %s/RELEASES_header %s/RELEASES",ipath,rundir))
	ofile	= sprintf("%s/RELEASES",rundir)
	write.table(alld,file=ofile,row.names=FALSE,col.names=FALSE,quote=F,append=TRUE)

cat("Successfully created:   ", ofile, "\n")
