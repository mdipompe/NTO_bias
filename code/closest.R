#Find element of vector closest to some value, return index

closest <- function(arr,val) {
  ret <- which(abs(arr - val) == min(abs(arr - val)))
  return(ret)
}