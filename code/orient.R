#Determines number of face-on (theta < theta_c) objects expected
n_face <- function(n,theta_c,down=FALSE,up=FALSE) {
  #Convert theta_c to radians
  theta_c_r <- theta_c * (pi/180.)
  if(theta_c == 0) {
    num_face <- 0
  }
  if(theta_c == 90) {
    num_face <- n
  }
  if(theta_c != 0 && theta_c != 90) {
    prob <- integrate(sin, 0, theta_c_r)
    num_face = n * prob$value
  }
  if(down) {
    num_face <- floor(num_face)
  }
  if(up) {
    num_face <- ceiling(num_face)
  }
  return(round(num_face))
}



#Determines number of edge-on (theta > theta_c) objects expected
n_edge <- function(n,theta_c,down=FALSE,up=FALSE) {
  #Convert theta_c to radians
  theta_c_r <- theta_c * (pi/180.)
  if(theta_c == 0) {
    num_edge <- n
  }
  if(theta_c == 90) {
    num_edge <- 0
  }
  if(theta_c != 0 && theta_c != 90) {
    prob <- integrate(sin, theta_c_r, 90*(pi/180.))
    num_edge = n * prob$value
  }
  if(down) {
    num_edge <- floor(num_edge)
  }
  if(up) {
    num_edge <- ceiling(num_edge)
  }
  return(round(num_edge))
}


#Generate random viewing angles to face-on (kind=1) or edge-on (kind=2) samples
viewing_angles <- function(n,theta_c,kind=1,seed=0) {
  #Convert theta_c to radians
  theta_c_r <- theta_c * (pi/180.)
  if(seed != 0) {
    set.seed(seed)
  }
  angs <- runif(n,0,1)

  if(kind == 1) {
    angles <- acos(1-angs*(1-cos(theta_c_r)))
  }
  if(kind == 2) {
    angles <- acos(cos(theta_c_r)-angs*cos(theta_c_r))
  }
  return(angles*180/pi)
}


  
  
  
  