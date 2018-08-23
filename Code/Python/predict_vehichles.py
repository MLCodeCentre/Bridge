from window_statistics import *
import argparse
import matplotlib.pyplot as plt
from model_fits import *
from progress.bar import Bar
from clean_ones import loadOnes


def cleanMinInds(min_inds, gap=2):

    clean_inds = [min_inds[0]]
    for ind in min_inds:
        if ind - clean_inds[-1] > gap*66.67:
            clean_inds.append(ind)
            
    return clean_inds

def rollingWindowModelFit(stat, fit_type, before, after):
    
    window_after = int(after * 66.67)
    window_before = int(before * 66.67)
    
    a = 3.84
    D = 18
    errors = []
    readings = 500
    bar = Bar('Processing', max=readings)
    for i in np.linspace(0, len(stat), readings):
        window = stat[max(0, int(i - window_before)): min(int(i + window_after), len(stat))]
        time = np.linspace(before, after, len(window))
        
        if fit_type == 'Gamma':
            fit = gamma.pdf(time, a)
        elif fit_type == 'Heat':
            fit = heatEquation(time, D, x=1)
            
        Es = [(window[ind] -  fit[ind])*(window[ind] -  fit[ind]) for ind, t in enumerate(time)]
        Es = [E for E in Es if not math.isnan(E)]
        error = sum(Es)/len(Es)
        errors.append(error)

        bar.next()
    bar.finish()
    
    plt.subplot(211)
    
    stat_time = [s/66.67 for s in range(len(stat))]
    plt.plot(stat_time, stat)
    
    error_threshold = 0.0012
    min_inds = [ind*(len(stat)/readings) for ind, error in enumerate(errors) if error < error_threshold]
    if len(min_inds) > 0:
        min_inds = cleanMinInds(min_inds)
       
    for min_ind in min_inds:
        window = stat[max(0, int(min_ind - window_before)): min(int(min_ind + window_after), len(stat))]
        time = np.linspace(before, after, len(window))
        if fit_type == 'Gamma':
            fit = gamma.pdf(time, a)
        elif fit_type == 'Heat':
            fit = heatEquation(time, D, x=1)
        
        fit_time = np.linspace(max(0, int(min_ind - window_before)) , min(int(min_ind + window_after), len(stat)), len(fit))
        fit_time = [t/66.7 for t in fit_time]
        plt.plot(fit_time, fit)
  
 
    plt.title('Accelerometer window variance')
    plt.subplot(212)
    error_time = [e*(len(stat)/readings)/66.67 for e in range(len(errors))]
    plt.plot(error_time, errors)
    plt.title('MSE of Fit on Data')
    plt.xlabel('Time [s]')
    plt.show()

    
def plotStats(stats, indexes):
    
    time = [t / 66.67 for t in range(len(stat))]
    plt.plot(time, stats)
    plt.scatter([index / 66.67 for index in indexes], [stat[index] for index in indexes])
    plt.xlabel('Time [s]')
    plt.title('Sliding Window Statistic Peaks')
    plt.show()

    
def main(args):

    stats, labels = createStatsAndLabels(args.thresh, args.chan, args.window_size, args.seconds, number=10)
    #stats = loadOnes(args.thresh, args.seconds)
    for stat in stats:
        rollingWindowModelFit(stat, 'Heat', 0.1, 5)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Calculate window stats')
    parser.add_argument('--thresh', '-t', type=str, help='the time thresholding in processing', default='360')
    parser.add_argument('--seconds', '-s', type=int, help='the amount of data shown (secs)', default=60)
    parser.add_argument('--chan', '-c', type=int, help='index of the channel in data array', default=2)
    parser.add_argument('--window_size', '-w', type=int, help='size of window, this is the number of readings, not seconds', default=5)
    parser.add_argument('--peak_thresh', '-pt', type=float, help='normalised peak min value', default=0.09)
    parser.add_argument('--peak_dist', '-pd', type=float, help='seconds between peaks', default=13)
    parser.add_argument("--show", type=str, const=True, nargs='?', help="show plot.")

    args = parser.parse_args()
    main(args)
