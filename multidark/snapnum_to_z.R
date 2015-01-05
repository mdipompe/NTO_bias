#Take the halo tables from multidark, add in redshift columns,
#write back out.  Removes need to convert between snapnum and z 
#all the time.

obsc <- read.table("halos_obscured.txt",header=TRUE,sep=",")
unob <- read.table("halos_unobscured.txt",header=TRUE,sep=",")
zinfo <- read.table("redshift_info.txt",header=TRUE,sep=",",col.names=c("id","snapnum","a","z"))

snapnums_used <- zinfo$snapnum[zinfo$snapnum > 34]

obsc_z <- numeric(length = length(obsc$snapnum))
unob_z <- numeric(length = length(unob$snapnum))

for (snap in snapnums_used) {
  obsc_z[obsc$snapnum == snap] <- zinfo$z[zinfo$snapnum == snap]
  unob_z[unob$snapnum == snap] <- zinfo$z[zinfo$snapnum == snap]
}

obsc$redshift <- obsc_z
unob$redshift <- unob_z

write.table(obsc,file = "halos_obscured_z.txt")
write.table(unob,file = "halos_unobscured_z.txt")