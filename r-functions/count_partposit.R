## Count number of particles in partposit* output from FLEXPART
#
#' @param fn filename
#' @param nspec number of species in file
#' @param maxn maximum number of particles to read
#' @return integer (number of particles in file)
#
##

count_partposit = function(fn, nspec=1, maxn=25000000){

	if (missing(fn)) fn = file.choose()

	if (!file.exists(fn)) {
		warning("File not found.")
		return(NULL)
	}

    # read file
    strm  = file(fn, open="rb")
    dummy = readBin(strm, "raw", n=4)

	#	itime
	itime = readBin(strm, "integer", n=1, size=4)
	cat("itime:", itime, "\n")

	nn.reals = 10
	idx = 1

	# main loop over all particles
	repeat{
	    dummy = readBin(strm, "raw", n=8)
		
		npoint = readBin(strm, "integer", n=1, size=4)
		if (length(npoint)==0) break
		if (npoint<0) break
		if (idx>maxn) break

		dummy = c(npoint,readBin(strm, "numeric", n=3, size=4), 
			readBin(strm, "integer", n=1, size=4), 
			readBin(strm, "numeric", n=nn.reals+1, size=4))

		idx = idx + 1
	}	#	end of loop over particles
	close(strm)

	return(idx)
}

