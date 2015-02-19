#Resample data into a log-normal distribution (log base 10!)
#Origdataframe is the full sample you want to reseample
#origvals is the column of data in origdataframe you want resampled
#   to lognormal

resample_lognorm <- function(origdataframe,origvals,meanlog,sdlog,n) {
  prob <- dlnorm(origvals,meanlog=log(10)*meanlog,sdlog=log(10)*sdlog)
  newsamp <- origdataframe[sample(nrow(origdataframe),
                                  size=n,replace=FALSE,prob=prob),]
  return(newsamp)
}