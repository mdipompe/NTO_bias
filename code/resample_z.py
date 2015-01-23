import numpy as np
from fit_dndz import fit_dndz

def closest(arr,val):
    #Finds/returns index of element in arr closest to val
    indx = np.abs(arr-val).argmin()
    return indx

def readsim(simfilename):
    #Read in multidark simulation data, put into recarray
    #with attributes for easy use
    data = np.loadtxt(simfilename,dtype='string',skiprows=1)
    data = data[:,1:]
    data = data.astype(np.float)
    out = np.recarray((len(data[:,1]),), dtype=[('snapnum',int), ('x',float),
                        ('y',float), ('z',float), ('Mvir',float),('Mtot',float),
                        ('Rvir',float), ('redshift',float)])
    out.snapnum = data[:,1]
    out.x = data[:,3]
    out.y = data[:,4]
    out.z = data[:,5]
#    out.Mvir = data[:6]
    out.Mtot = data[:,7]
    out.Rvir = data[:,8]
    out.redshift = data[:,9]
    
    return out
    
def readsimz(zfilename):
    #Read in snapnum/z master data, but in recarray
    data = np.loadtxt(zfilename, skiprows=1, delimiter=',')
    out = np.recarray((len(data[:,0]),), dtype=[('snapnum',int),('a',float),
                        ('z',float)])
    out.snapnum = data[:,1]
    out.a = data[:,2]
    out.z = data[:,3]
    
    return out
    
    
def genweights(realz,simdata_zs):
    #Generate weights for each z in the simulation data
    zs,zfit = fit_dndz(realz,0.2)
    simzdata = readsimz("redshift_info.txt")
    simzdata = simzdata[simzdata.snapnum > 34]
    simz,simzfit = fit_dndz(simdata_zs,0.3)
    simzfit[simzfit == 0] = 1.0e-6
    
    weight = np.zeros(len(simdata_zs))
    
    for z in simzdata.z:
        renorm = simzfit[closest(simz,z)]
        weight[simdata_zs == z] = zfit[closest(zs,z)]/renorm
    
    weight = (weight/max(weight))/sum(weight/max(weight))
    return weight
        
        
def resample(origdata,n,weights,seed=616,replace=0): 
    #Resample the original data to size n.  Must supply weights
    #even if they are all equal.  Must set a specific seed
    #(or leave the default) to work properly!
    if replace == 0:
        repstring = 'False'
    else:
        repstring = 'True'
    
    colnames = origdata.dtype.names    
    newdata = np.take(origdata,np.arange(0,n,1))
    for name in colnames:
        np.random.seed(seed)
        cmd = 'newdata.' + name + '=np.random.choice(origdata.' + name + ',size=' + str(n) + ',replace=' + repstring + ',p=weights)'
        exec cmd

    return newdata        


def getnewsample(zfile,simdatafile,n):
    #Main code, calls all the others and returns 
    #final resampled data
    realz = np.loadtxt(zfile)
    simdata = readsim(simdatafile)
    
    w = genweights(realz,simdata.redshift)
    
    newsample = resample(simdata,n,w)
    
    return newsample
        


    