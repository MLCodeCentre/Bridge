import numpy as np
import matplotlib.pyplot as plt
from accelerometers import getDataFiles
import argparse
import os
from random import shuffle, random
from detect_peaks import detect_peaks
from progress.bar import Bar
import gc


def getNumPeaks(stats, min_dist, min_thresh, plot=False):
    
    indices = detect_peaks(stats, mph=min_thresh, mpd=min_dist*66.67)
    
    vehicles = len(indices)
    times = [index/66.67 for index in indices]

    if plot:
        plt.subplot(212)
        time = [t / 66.67 for t in range(len(stats))]
        plt.plot(time, stats)
        plt.scatter([index/66.67 for index in indices], [stats[index] for index in indices])
        plt.xlabel('Time [s]')
        plt.title('Sliding Window Statistic Peaks')
        plt.show()
        
    return vehicles, times


def normaliseChanData(data, calibration=1.7572e-04):

    return (data - np.mean(data)) * calibration


def getWindowStats(data, window_size):

    stats = np.zeros(len(data))
    for ind in range(window_size, len(data)-window_size):
        window_data = data[ind-window_size: ind+window_size]
        stats[ind] = sum([w*w for w in window_data])/len(window_data)

    return stats
    

def getChanData(file, chan, seconds):

    data_length = int(seconds*66.6777)
    data = np.load(file)
    
    return data[:data_length, chan]


def plotResponseAndWindowStats(args):

    num_clifton = 1
    num_leigh = 0
    files = getDataFiles(num_clifton, num_leigh, args.thresh)

    for file in files:
        chan_data = getChanData(file, args.chan, args.seconds)
        time = [t/66.67 for t in range(len(chan_data))]
        plt.subplot(211)
        plt.plot(time, chan_data)
        plt.title('Accelerometer 40lw North Response')

        chan_data = normaliseChanData(chan_data)
        stats = getWindowStats(chan_data, args.window_size)
        getNumPeaks(stats, args.peak_dist, args.peak_thresh)
		

def getSetAccuracy(sets, thresh, chan, seconds, window_size, peak_dist, peak_thresh):
    
    preds = []
    labels = []

    for (num_clifton, num_leigh) in sets:
        files = getDataFiles(num_clifton, num_leigh, thresh)
        shuffle(files)
        files = files[:100]

        for file in files:
            chan_data = getChanData(file, chan, seconds)
            chan_data = normaliseChanData(chan_data)
            stats = getWindowStats(chan_data, window_size)
            
            pred = getNumPeaks(stats, peak_thresh, peak_dist)
            preds.append(pred)

            label = num_clifton + num_leigh
            labels.append(label)

            print(label, pred)
            if label != pred:
                time = [t/66.67 for t in range(len(chan_data))]
                plt.plot(time, chan_data)
                plt.plot(time, stats)
                plt.show()

    accuracy = len([pred for ind, pred in enumerate(preds) if labels[ind] == pred])/len(preds)
    return accuracy


def createStatsAndLabels(thresh, chan, window_size, seconds, set="B", number=None):
    #set B
    # below is a full set of (num_clifton, num_leigh)
    if set == "B":
        sets = [      (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
                (2,0),(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),
                (3,0),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),
                (4,0),(4,1),(4,2),(4,3),(4,4),(4,5),(4,6),
                (5,0),(5,1),(5,2),(5,3),(5,4),(5,5),(5,6),
                (6,0),(6,1),(6,2),(6,3),(6,4),(6,5),(6,6)]
    #set A
    else:
        sets = [(1,0), (0,1)]
    
    stats = []
    labels = []
    
    print('Creating Channel Data')
    # if requested a smaller number of files than max
    for (num_clifton, num_leigh) in sets:
        files = getDataFiles(num_clifton, num_leigh, thresh)
        for file in files:
            if (number is None) or (number is not None and len(stats)) < number:
                
                labels.append(num_clifton + num_leigh)

                chan_data = getChanData(file, chan, seconds)
                chan_data = normaliseChanData(chan_data)
                chan_stats = getWindowStats(chan_data, window_size)

                stats.append(chan_stats)
        
    print("Created {} files".format(len(stats)))
    return stats, labels

     
def createChansAndLabels(thresh, chan, window_size, seconds, set="B", number=None):
    #set B
    # below is a full set of (num_clifton, num_leigh)
    if set == "B":
        sets = [      (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
                (2,0),(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),
                (3,0),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),
                (4,0),(4,1),(4,2),(4,3),(4,4),(4,5),(4,6),
                (5,0),(5,1),(5,2),(5,3),(5,4),(5,5),(5,6),
                (6,0),(6,1),(6,2),(6,3),(6,4),(6,5),(6,6)]
    #set A
    else:
        sets = [(1,0), (0,1)]
    
    chans = []
    labels = []
    
    print('Creating Channel Data')
    # if requested a smaller number of files than max
    for (num_clifton, num_leigh) in sets:
        files = getDataFiles(num_clifton, num_leigh, thresh)
        for file in files:
            if (number is None) or (number is not None and len(stats)) < number:
                
                labels.append(num_clifton + num_leigh)

                chan_data = getChanData(file, chan, seconds)
                chan_data = normaliseChanData(chan_data)

                chans.append(chan_data)
        
    print("Created {} files".format(len(chans)))
    return chans, labels



def main(args):

    peak_dist_min = 0   
    peak_dist_max = 40
    peak_thresh_min = 0.00
    peak_thresh_max = 0.40

    peak_dist_range = np.arange(peak_dist_min, peak_dist_max, 5)
    peak_thresh_range = np.arange(peak_thresh_min, peak_thresh_max, 0.05)

    accuracies = np.zeros((peak_thresh_range.shape[0], peak_dist_range.shape[0]))
    print(accuracies.shape)

    stats, labels = createStatsAndLabels(args.thresh, args.chan, args.window_size, args.seconds)

    print('Calculating Accuracies')
    bar = Bar('Processing', max=np.prod(accuracies.shape))
    
    for i, peak_thresh in enumerate(peak_thresh_range):
        for j, peak_dist in enumerate(peak_dist_range):
            correct = 0
            for label, stat in zip(labels, stats):
                vehicles, times = getNumPeaks(stat, peak_dist, peak_thresh, plot=False)
                #print(vehicles,  label)
                if vehicles == label:
                    correct = correct + 1
            accuracy = correct/len(labels)
            accuracies[i, j] = accuracy
            bar.next()
    bar.finish()
    
    #accuracies = np.flipud(accuracies)
    #accuracies = np.fliplr(accuracies)
    
    (max_peak_thresh_ind, max_peak_dist_ind) = np.unravel_index(accuracies.argmax(), accuracies.shape)
    
    print(max_peak_thresh_ind, max_peak_dist_ind)
    print(accuracies[max_peak_thresh_ind, max_peak_dist_ind])
    
    max_peak_thresh = peak_thresh_range[max_peak_thresh_ind]
    max_peak_dist = peak_dist_range[max_peak_dist_ind]
    
    print(max_peak_thresh, max_peak_dist)

    plt.imshow(accuracies, aspect='auto', extent=(peak_dist_min, peak_dist_max, peak_thresh_min, peak_thresh_max))
    plt.colorbar()
    plt.title('2+ vehicle prediction accuracy for varying minimum peak heights and distances')
    plt.ylabel('Minimum normalised height of peak')
    plt.xlabel('Minimum distance between peaks [s]')

    plt.show()


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Calculate window stats')
    parser.add_argument('--thresh', '-t', type=str, help='the time thresholding in processing', default='120')
    parser.add_argument('--seconds', '-s', type=int, help='the amount of data shown (secs)', default=60)
    parser.add_argument('--chan', '-c', type=int, help='index of the channel in data array', default=2)
    parser.add_argument('--window_size', '-w', type=int, help='size of window, this is the number of readings, not seconds', default=5)

    args = parser.parse_args()
    #slowWindow(args)
    #plotResponseAndWindowStats(args)
    main(args)

