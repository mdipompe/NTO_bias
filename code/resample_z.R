#Resample halo dndz to match observed dndz

#Fit z distrubtions
source("fit_dndz.R")
source("closest.R")
fit_obsc <- fit_dndz("obsc_z_used.txt",0.15)
fitz_obsc <- fit_obsc[[1]]
fitp_obsc <- fit_obsc[[2]]
fit_unob <- fit_dndz("unobsc_z_used.txt",0.15)
fitz_unob <- fit_unob[[1]]
fitp_unob <- fit_unob[[2]]

#Read in simulated data
obsc <- read.table("halos_obscured_z.txt", header = TRUE, sep = "")
unob <- read.table("halos_unobscured_z.txt", header = TRUE, sep = "")

#Read in snapnum to redshift conversion data
zinfo <- read.table("redshift_info.txt", header = TRUE, sep = ",",
                    col.names=c("id","snapnum","a","z"))
zs <- zinfo$z[zinfo$snapnum > 34]

#Fit simulated data z dist for re-normalizing weights
orig <- density(obsc$redshift,bw=0.15)

#Generate weights for each z and sample
for (i in 1:length(zs)) {
  renorm <- orig$y[closest(orig$x,zs[i])]
  obsc$weight[obsc$redshift == zs[i]] <- fitp_obsc[closest(fitz_obsc,zs[i])]/renorm
  unob$weight[unob$redshift == zs[i]] <- fitp_unob[closest(fitz_unob,zs[i])]/renorm
}

#Resample to right size, z distribution
newobsc <- obsc[sample(nrow(obsc), size=74889, replace = FALSE, prob = obsc$weight), ]
newunob <- unob[sample(nrow(unob), size=102740, replace = FALSE, prob = unob$weight), ]

#Make some plots as a check
plot(density(newobsc$redshift,bw=0.2),col="red")
lines(density(obsc$redshift,bw=0.2),col="black")
realdndz_obsc <- read.table("obsc_z_used.txt",header=FALSE)
lines(density(realdndz_obsc$V1,bw=0.2),col="blue")

plot(density(newunob$redshift,bw=0.2),col="red")
lines(density(unob$redshift,bw=0.2),col="black")
realdndz_unob <- read.table("unobsc_z_used.txt",header=FALSE)
lines(density(realdndz_unob$V1,bw=0.2),col="blue")

#Compare real data and resampled distributions with KS test
comp_obsc <- ks.test(realdndz_obsc$V1,newobsc$redshift)
comp_unob <- ks.test(realdndz_unob$V1,newunob$redshift)

#Write out resampled data
write.table(newobsc,file = "obsc_halo_resampled.txt",sep = "   ",)
write.table(newunob,file = "unob_halo_resampled.txt",sep = "   ",)
