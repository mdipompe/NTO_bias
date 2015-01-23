import numpy as np
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

def fit_dndz(zvals,binsize):
    #Fit a redshift distribution and normalize it
    bins = np.arange(0,max(zvals)+binsize,binsize)
    hist,bin_edges = np.histogram(zvals,bins=bins)
    bin_cent = np.empty(len(hist))
    for i in range(0,len(bin_cent)): 
        bin_cent[i] = bins[i]+((bins[i+1]-bins[i])/2)
    bin_cent = np.insert(bin_cent,0,0)
    bin_cent = np.append(bin_cent,3)
    hist = np.insert(hist,0,0)
    hist = np.append(hist,0)
    
    step = 0.01
    fitzfunc = interp1d(bin_cent,hist,kind='cubic')
    zs = np.arange(0,3.01,step)
    fitz = fitzfunc(zs)
    fitz[fitz < 0] = 0.
    
    area = sum(fitz*step)
    nfitz = fitz/area

    return (zs,nfitz)

def main():
    args = sys.argv[1:]
    if not args:
        print 'usage: python fit_dndz.py z_file binsize'

    zvals = np.loadtxt(args[0])
    zs,fitz = fit_dndz(zvals,args[1])
    plt.plot(zs,fitz,'--')



if __name__ == '__main__':
    main()
