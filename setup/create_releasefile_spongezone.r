rm(list=ls())
#
## Script to create a RELEASE file using a spongezone of the domain
# --> mimicking a domain filling setup for an RCM
#
## STEPS
# 1) Initialization 
# 	- entire domain
# 2) Boundary releases
# 	- spongezone
# 
## Options: 
# Rscript create_releasefile_spongezone.r init np dstart dend rundir
#  - init: 	initilization? [y|n] (additional release at dstart from ALL grid cells)
#  - np: 	number of particles to be released at each grid point (spongezone) 
#  - dstart: 	startdate of RELEASE
#  - dend: 	enddate of RELEASE
#  - rundir:	run-directory, where RELEASE file should be written
#  - bx: 	relaxation zone grid points to skip for the sponge zone release ((optional; default = 6))
#  - inp: 	number of particles to be released at initialization ((optional; default = 50))
#
##
# Example: 
# Rscript create_releasefile_spongezone.r y 100 "20030101 100000" "20030101 100000" /user/scratch/gent/gvo000/gvo00090/vsc42383/flexpart_run/tests/init_v1 6 50
# JKe 24-04-2018
#
library(ncdf4)

# read command line options
args 	= commandArgs(TRUE)
stopifnot(length(args) >= 5)
init   	= args[1]
np   	= as.double(args[2])
dstart	= args[3]
dend	= args[4]
rundir	= args[5] 
bx	= args[6]
if(is.null(bx)){bx=6}
npi	= args[7]
if(is.null(npi)){npi=50}

## SETTINGS
# paths
        ipath="/user/data/gent/gvo000/gvo00090/vsc42383/tools/flexpart/flexpart-utils/setup"
	setwd(ipath)
# grid
        gridfile= nc_open("/user/data/gent/gvo000/gvo00090/vsc42383/data/terrsysmp/staticdata/focus_mask_eur11_315x315.nc")
        lon	= ncvar_get(gridfile,"lon")
        lat	= ncvar_get(gridfile,"lat")
	nlon	= dim(lon)[1]
	nlat	= dim(lon)[2]

##
## RELEASE FILE (OUTPUT)
##
     mag	= 1
     lzl	= 0.0
     uzl 	= 10000.0
     tme	= 1.0
     sep	= "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

# a) Initilization
  if(init=="y"){
	ilon	= round(c(lon),digits=4)
	ilat	= round(c(lat),digits=4)

	alld=NULL
	for(i in 1:length(ilon)){
	  alld	= c(alld,c(dstart,dstart,ilon[i],ilat[i],ilon[i],ilat[i],mag,lzl,uzl,npi,tme,i,sep))
	}
	ofile	= sprintf("%s/RELEASES",rundir)
	system(paste("cp ../templates/RELEASES_header", ofile))
	write.table(alld,file=ofile,row.names=FALSE,col.names=FALSE,quote=F,append=TRUE)
  }

# b) Sponge zone
#	ilon	= round(c(lon[bx,bx],lon[nlon-bx,bx],lon[bx,nlat-bx],lon[nlon-bx,nlat-bx]),digits=4)
#	ilat	= round(c(lat[bx,bx],lat[nlon-bx,bx],lat[bx,nlat-bx],lat[nlon-bx,nlat-bx]),digits=4)
#
#	alld=NULL
#	for(i in 1:length(ilon)){
#	  alld	= c(alld,c(dstart,dend,ilon[i],ilat[i],ilon[i],ilat[i],mag,lzl,uzl,np,tme,i,sep))
#	}
#	ofile	= sprintf("%s/RELEASES",rundir)
#	if(init=="n"){system(paste("cp ../templates/RELEASES_header", ofile))}
#	write.table(alld,file=ofile,row.names=FALSE,col.names=FALSE,quote=F,append=TRUE)

cat("Successfully created:   ", ofile, "\n")
