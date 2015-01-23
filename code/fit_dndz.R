#Read in z values of sample, fit (used loosely here...) and normalize
#to provide dndz

fit_dndz <- function(file,binning) {
  #Read in the data, convert to list
  zs <- read.table(file, header = FALSE)
  zs <- zs$V1

  #Plot normalized histogram
  hist(zs,breaks = seq(from = 0, to = ceiling(max(zs)), by = binning),
       freq = FALSE, xlab = "z", ylab = "dndz")

  #Fit smooth function, force (0,0), overplot
  fit <- density(zs, bw = binning)
  x <- c(0, fit$x[fit$x > 0])
  y <- c(0, fit$y[fit$x > 0])
  lines(x,y)
  
  return(list(x,y))
}