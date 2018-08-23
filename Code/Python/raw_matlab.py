import glob
import os
from window_statistics import createChansAndLabels
import argparse
import matplotlib.pyplot as plt
import numpy as np
import scipy.io

def loadOnes(thresh, seconds):
     
    file_dir = os.path.join('Data', 'Clean Ones', thresh, '{}secs'.format(str(seconds)),'*')
    files = glob.glob(file_dir)
    stats = []
    
    for file in files:
        data = np.load(file)
        data = data[:int(seconds*66.67)]
        stats.append(data)
    print('Loaded {} clean data files'.format(len(stats)))
    return stats


def main(args):

    chans, labels = createStatsAndLabels(args.thresh, args.chan, args.window_size, args.seconds, set="A")
    
    data_out_dir = os.path.join('Data', 'Matlab Clean Ones', args.thresh, '{}secs'.format(str(args.seconds)))
    
    if not os.path.exists(data_out_dir):
        os.makedirs(data_out_dir)
    
    for ind, chan in enumerate(chans):
        plt.plot(chan)
        plt.show()
        decision = input('Is the Data clean? (Y/N)')

        if decision in ['y','Y','yes','Yes']:
            print('saved')
            file_name = str(ind)
            scipy.io.savemat(os.path.join(data_out_dir, file_name), dict(data=chan))
                        
        elif decision in ['n','N','no','No']:
            print('not saved')

    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Calculate window stats')
    parser.add_argument('--thresh', '-t', type=str, help='the time thresholding in processing', default='360')
    parser.add_argument('--seconds', '-s', type=int, help='the amount of data shown (secs)', default=60)
    parser.add_argument('--chan', '-c', type=int, help='index of the channel in data array', default=2)
    parser.add_argument('--window_size', '-w', type=int, help='size of window, this is the number of readings, not seconds', default=3)
      
    args = parser.parse_args()
    main(args)
