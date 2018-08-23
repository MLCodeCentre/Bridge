import numpy as np
import pandas as pd
from scipy import stats, integrate
import matplotlib.pyplot as plt
import seaborn as sns
from time import mktime
from datetime import timezone
import glob
import os
from scipy import signal
from random import shuffle
import matplotlib.ticker as ticker
import argparse
#sns.set(color_codes=True)


def getDataFiles(num_clifton, num_leigh_woods, threshold):

    files = glob.glob("Data/Accelerometer Responses New/{}/*Clifton{}_Leigh{}*.npy".format(threshold, num_clifton, num_leigh_woods))
        
    return files

def plotChan4lw(files, num_clifton, num_leigh_woods, num_figs, data_length):

    plt.close() 
    title_name = 'Cliton: {}, Leigh: {} \n acceleration_40lw_northside'.format(num_clifton, num_leigh_woods)
    chan = 2

    shuffle(files)
    if len(files) < num_figs:
        print('r{} files found'.format(len(files)))
    else:
        files = files[:num_figs]
    
    for file in files:

        data = np.load(file)
        chan_data = data[:data_length, 2]
        time = [t / 66.67 for t in range(len(chan_data))]

        plt.figure()
        plt.plot(time, chan_data)
        plt.title(title_name)
        plt.xlabel('Time [s]')

    plt.show()


def plotData(files, num_clifton, num_leigh_woods, number_figs, data_length):

    plt.close() 
    titles = ['acceleration_11lw_northside',
                              'acceleration_11lw_southside',
                              'acceleration_40lw_northside',
                              'acceleration_40lw_southside',
                              'displacement_40lw_northside',
                              'displacement_40lw_southside']

    shuffle(files)
    files = files[:number_figs]
    for file in files:
        data = np.load(file)
        f, axarr = plt.subplots(6, sharex=True)
        plt.suptitle(file.split('/')[-1])
        for i in range(0,6):
            x = data[:data_length, i]
            axarr[i].plot(x)
            axarr[i].set_title(titles[i])
            ticks_x = ticker.FuncFormatter(lambda x, pos: '{0:.4d}'.format((x/67)))
            axarr[i].xaxis.set_major_formatter(ticks_x)

        f.subplots_adjust(hspace=0.4)
        axarr[5].set_xlabel('Time [s]')

    plt.show()

def main(args):

    clifton = 0
    leigh_woods = 1
    files = getDataFiles(args.clifton, args.leigh, args.thresh)
    plotChan4lw(files, args.clifton, args.leigh, args.figs, int(args.seconds*66.67))


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Plot accelerometer responses.')
    parser.add_argument('clifton', type=int, help='number of cars from Clifton brigde in minute')
    parser.add_argument('leigh', type=int, help='number of cars from Clifton brigde in minute')
    parser.add_argument('--figs', '-f', type=int, help='number of figures to create', default=1)
    parser.add_argument('--thresh', '-t', type=str, help='the time thresholding in processing', default='60')
    parser.add_argument('--seconds', '-s', type=int, help='the amount of data shown (secs)', default=60)

    args = parser.parse_args()
    main(args)