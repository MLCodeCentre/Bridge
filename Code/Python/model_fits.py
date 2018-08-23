import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import beta, gamma, probplot
from window_statistics import createStatsAndLabels, getNumPeaks
import argparse
from random import random
import math
import glob
import os
from clean_ones import loadOnes


def heatEquation(time, D, x, a=0):

    k = [(1 / (np.sqrt(4 * np.pi * D * t))) * np.exp(-np.power((x - a), 2) / (4 * D * t)) for t in time]
    return k
    

def dkdD(t, D, x):

    dk = (1 / np.sqrt(4 * np.pi * t * np.power(D, 3))) * ((np.power(x, 2)/(4 * t * D)) - 0.5) \
    * np.exp(-(np.power(x, 2) / (4 * t * D)))
    return dk

    
def dldD(stat, D, time, x):
    
    dls = ([(-dkdD(t, D, x) * (stat[ind] - k(t, D, x))) for ind, t in enumerate(time)])
    dl = sum([dl for dl in dls if not math.isnan(dl)])
    dl = 2*dl/len(dls)
    return dl
    

    
def getEventWindow(stat, window_before, window_after):

    time = [t/66.67 for t in range(len(stat))]

    min_dist = 10
    min_thresh = 0.2
    vehicles, times = getNumPeaks(stat, min_dist, min_thresh, plot=False)
    
    if len(times) == 0:
        times = [0]
    
    window_before = int(window_before*66.67)
    window_after = int(window_after*66.67)
    window_before = max(0,int(times[0]*66.67 - window_before))
    window_after = min(int(times[0]*66.67 + window_after), len(stat))
    
    time = time[window_before: window_after]
    event_time = times[0] - min(time)
    
    time = [t - min(time) for t in time]
    stat = stat[window_before: window_after]
    
    return [stat, event_time, time]

def fitBetaDistribution(stat, event_time, time, show, amin=1, amax=4, iters=100):

    errors = []
    a = []
    b = []
    time = np.linspace(0, 1, len(time))
    a = 2
    b = 20
    
    for a in np.linspace(1,3,10):
        betas = beta.pdf(time,a,b)
        betas = [be for be in betas]
        plt.plot(time, betas, label='a={}, b={}'.format(str(a), str(b)))
    plt.legend()
    plt.show()

    # time = np.linspace(1, 20, len(time))
    
    # for ai in np.linspace(amin, amax, iters):
       # gammas = gamma.pdf(time, ai)
       # Es = [stat[ind] - gammas[ind] for ind, t in enumerate(time)]
       # Es = [E for E in Es if not math.isnan(E)]
       # error = sum([np.power(E, 2) for E in Es])/len(Es)
       # errors.append(error)
       # a.append(ai)
        
    # argMina = a[errors.index(min(errors))]
    # print('a: {:.2f}, Error: {:.6f}'.format(argMina, min(errors)))
    # new_fit = [gamma.pdf(t, 3.42, event_time) for t in time]
    
    # if show:
        # plt.plot(time, stat)
        # plt.plot(time, new_fit, label='a={:.2f}'.format(argMina))
        # plt.legend()
        # plt.show()
        
    # return argMina, min(errors)

def fitGammaDistribution(stat, event_time, time, show, amin=1, amax=4, iters=100):

    errors = []
    a = []

    time = np.linspace(1, 20, len(time))
    
    for ai in np.linspace(amin, amax, iters):
       gammas = gamma.pdf(time, ai)
       Es = [stat[ind] - gammas[ind] for ind, t in enumerate(time)]
       Es = [E for E in Es if not math.isnan(E)]
       error = sum([np.power(E, 2) for E in Es])/len(Es)
       errors.append(error)
       a.append(ai)
        
    argMina = a[errors.index(min(errors))]
    print('a: {:.2f}, Error: {:.6f}'.format(argMina, min(errors)))
    new_fit = [gamma.pdf(t, 3.42, event_time) for t in time]
    
    if show:
        plt.plot(time, stat)
        plt.plot(time, new_fit, label='a={:.2f}'.format(argMina))
        plt.legend()
        plt.show()
        
    return argMina, min(errors)
       

def fitHeatEquation(stat, event_time, time, show, Dmin=10, Dmax=30, iters=100):
    
    errors = []
    Ds = []
    
    for Di in np.linspace(Dmin, Dmax, iters):
    
       heats = heatEquation(time, Di, event_time)
       
       Es = [(stat[ind] - heats[ind])*(stat[ind] - heats[ind]) for ind, t in enumerate(time)]
       Es = [E for E in Es if not math.isnan(E)]
       #error = sum([np.power(E, 2) for E in Es])/len(Es)
       error = sum(Es)
       errors.append(error)
       Ds.append(Di)
        
    argMinD = Ds[errors.index(min(errors))]
    print('D: {:.2f}, Error: {:.6f}'.format(argMinD, min(errors)))
    new_fit = heatEquation(time, argMinD, event_time)
    
    if show:
        plt.plot(time, stat)
        plt.plot(time, new_fit, label='D={:.2f}'.format(argMinD))
        plt.legend()
        plt.show()
        
    return argMinD, min(errors)
    
    
def main(args):

    #stats, labels = createStatsAndLabels(args.thresh, args.chan, args.window_size, args.seconds, set="A", number=5)
    stats = loadOnes(args.thresh, args.seconds)
    
    # for stat in stats:
        # [event_stat, event_time, time] = getEventWindow(stat, 0.2, 3) 
        # fitBetaDistribution(stat, event_time, time, args.show)
    
    # # -------------Gamma------------- #
    # print('\nFitting Gamma Distribution to Event Response')
    # params = []
    # errors = []
    # for stat in stats:
        # [event_stat, event_time, time] = getEventWindow(stat, 0.2, 3) 
        # a, error = fitGammaDistribution(event_stat, event_time, time, args.show)
        # params.append(a)
        # errors.append(error)
        
    # print('\n--------Results--------')
    # print('Mean a: {}'.format(np.mean(a)))
    # print('MSE of fit: {:.6f}\n\n'.format(np.mean(error)))
    
    # -------------Heat Equation------------- #
    print('\nFitting Heat Equation to Event Response')
    params = []
    errors = []
    for stat in stats:
        [event_stat, event_time, time] = getEventWindow(stat, 0.1, 5)
        D, error = fitHeatEquation(event_stat, event_time, time, args.show)
        params.append(D)
        errors.append(error)
        
    print('\n--------Results--------')
    print('Mean D: {}'.format(np.mean(D)))
    print('MSE of fit: {:.6f}\n\n'.format(np.mean(error)))

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Calculate window stats')
    parser.add_argument('--thresh', '-t', type=str, help='the time thresholding in processing', default='360')
    parser.add_argument('--seconds', '-s', type=int, help='the amount of data shown (secs)', default=60)
    parser.add_argument('--chan', '-c', type=int, help='index of the channel in data array', default=2)
    parser.add_argument('--window_size', '-w', type=int, help='size of window, this is the number of readings, not seconds', default=3)
    parser.add_argument("--show", type=str, const=True, nargs='?', help="show plot.")
    
    args = parser.parse_args()
    main(args)