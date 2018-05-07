#
library(ncdf4)
library(fields)
library(RColorBrewer)
library(abind)
library(maptools)
library(Hmisc)

# Use UGent Panno Font 
# loaded via https://statr.me/2014/01/using-system-fonts-in-r-graphs/ using showtext
library(showtext)
font_add("ugent", regular = "/user/scratch/gent/gvo000/gvo00090/vsc42383/testbed/ttfs/UGentPannoText-Medium.ttf")

## SETTINGS
# worldmaps
        worldmaps = readShapeSpatial("/user/data/gent/gvo000/gvo00090/vsc42383/data/terrsysmp/staticdata/TM_WORLD_BORDERS-0.2.shp")
# colors
	colera	= brewer.pal("Set1",n=4)[1]
	col1d	= brewer.pal("Set1",n=4)[3]
  	col3d	= brewer.pal("Set1",n=4)[2]
# paths
        ipath="/user/data/gent/gvo000/gvo00090/vsc42383/tools/flexpart/flexpart-utils/setup"
        setwd(ipath)
# grid
        gridfile= nc_open("/user/data/gent/gvo000/gvo00090/vsc42383/data/terrsysmp/staticdata/grid_cosmo.nc")
        clon    = ncvar_get(gridfile,"lon")
        clat    = ncvar_get(gridfile,"lat")
        nclon   = dim(clon)[1]
        nclat   = dim(clon)[2]
        # cut COSMO domain to CCLM domain
        lon     = ncvar_get(gridfile,"lon")[5:440,5:428]
        lat     = ncvar_get(gridfile,"lat")[5:440,5:428]
        nlon    = dim(lon)[1]
        nlat    = dim(lon)[2]


# PLOT
pdf("/user/data/gent/gvo000/gvo00090/vsc42383/plots/flexpart/FLEXPART_CORDEX-domain_setups.pdf",width=12,height=8)
showtext.begin()                ## turn on showtext
	par(mar=c(0.5,0.5,0.5,0.5),oma=c(0,0,0,0),mgp=c(1.75,0.75,0))
	plot(c(-45,70),c(20,75),t="n",xlab="",ylab="",xaxt="n",yaxt="n")
        plot(worldmaps,col=adjustcolor("white",0.1),add=T,xlim=c(-55,75),ylim=c(20,75),lwd=0.75, usePolypath = FALSE, border="grey50")
	# CORDEX original
	lines(clon[1,],clat[1,],t="l",lwd=2,col="black")
	lines(clon[,1],clat[,1],t="l",lwd=2,col="black")
	lines(clon[,nclat],clat[,nclat],t="l",lwd=2,col="black")
	lines(clon[nclon,],clat[nclon,],t="l",lwd=2,col="black")
	# CLM-PARFLOW
	lines(lon[1,],lat[1,],t="l",lwd=2,col="black",lty=2)
	lines(lon[,1],lat[,1],t="l",lwd=2,col="black",lty=2)
	lines(lon[,nlat],lat[,nlat],t="l",lwd=2,col="black",lty=2)
	lines(lon[nlon,],lat[nlon,],t="l",lwd=2,col="black",lty=2)
	# RELEASE 1 (full) ((424x412 = 174.688))
	bx1      = 6
	lines(lon[bx1,bx1:(nlat-bx1)],lat[bx1,bx1:(nlat-bx1)],t="l",lwd=3,col=col3d,lty=1)
	lines(lon[bx1:(nlon-bx1),bx1],lat[bx1:(nlon-bx1),bx1],t="l",lwd=3,col=col3d,lty=1)
	lines(lon[bx1:(nlon-bx1),nlat-bx1],lat[bx1:(nlon-bx1),nlat-bx1],t="l",lwd=3,col=col3d,lty=1)
	lines(lon[nlon-bx1,bx1:(nlat-bx1)],lat[nlon-bx1,bx1:(nlat-bx1)],t="l",lwd=3,col=col3d,lty=1)
	# RELEASE 2 (smaller) ((350x352 = 123.200))
	ixs	= 65
	ixe	= nlon-10
	iys	= 56
	iye	= nlat-16
	lines(lon[ixs,iys:iye],lat[ixs,iys:iye],t="l",lwd=3,col=col1d,lty=1)
	lines(lon[ixs:ixe,iys],lat[ixs:ixe,iys],t="l",lwd=3,col=col1d,lty=1)
	lines(lon[ixs:ixe,iye],lat[ixs:ixe,iye],t="l",lwd=3,col=col1d,lty=1)
	lines(lon[ixe,iys:iye],lat[ixe,iys:iye],t="l",lwd=3,col=col1d,lty=1)
	# RELEASE 3 (focus)  ((302x244 = 73.688))
	ixs	= 65
	ixe	= nlon-86
	iys	= 74
	iye	= nlat-108
	lines(lon[ixs,iys:iye],lat[ixs,iys:iye],t="l",lwd=3,col=colera,lty=1)
	lines(lon[ixs:ixe,iys],lat[ixs:ixe,iys],t="l",lwd=3,col=colera,lty=1)
	lines(lon[ixs:ixe,iye],lat[ixs:ixe,iye],t="l",lwd=3,col=colera,lty=1)
	lines(lon[ixe,iys:iye],lat[ixe,iys:iye],t="l",lwd=3,col=colera,lty=1)
	# legend
	legend("bottomleft",
		c("CORDEX","CORDEX - sponge","","F1: (424x412) - ideal","F2: (361x352)", "F3: (285x242)"),
		col=c("black","black",NA,col3d,col1d,colera),lty=c(1,2,NA,1,1,1),lwd=c(2,2,NA,3,3,3),bty="n",ncol=1)	
	#legend("bottom",	
		#c("CORDEX","F1: ideal (424x412)","CORDEX - relax","F2: (361x352)",NA, "F3: (285x242)"),
		#col=c("black",col3d,"black",col1d,NA,colera),lty=c(1,1,2,1,NA,1),lwd=c(2,3,2,3,3),bty="n",ncol=3)	
showtext_end()                  ## turn off showtext
dev.off()
