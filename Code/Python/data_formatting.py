import pandas as pd
import time
import datetime
import os
import numpy as np
import glob
import gc
import json
from collections import defaultdict, Counter
from progress.bar import Bar
import sys
import scipy.io

def createMatFiles():

    numpy_dir = 'Data/Clean Twos/60/60secs/*.npy'
    files = glob.glob(numpy_dir)

    for file in files:
        info = file.split('\\')
        print(info)
        file_name = info[-1].replace('.npy','')
        print(file_name)
        #out_file = os.path.join('Data/Matlab/Clean Twos/60/60secs/', thresh, file_name)
        file_dir = 'Data/Matlab/Clean Twos/60/60secs/'
        if not os.path.exists(file_dir):
            os.makedirs(file_dir)
        data = np.load(file)
        scipy.io.savemat(os.path.join(file_dir, file_name), dict(data=data))


def createData(file, toll_dict, max_timestamp, min_timestamp, after_thresh=480, before_thresh=480):

    out_dir = os.path.join('Data', 'Accelerometer Responses New', str(after_thresh))

    if not os.path.exists(out_dir):
        os.makedirs(out_dir)

    df_all = pd.read_csv(file)
    
    for timestamp, info in toll_dict.items():

        timestamp = (float(timestamp))
        after = info['after']
        before = info['before']

        if timestamp < max_timestamp and timestamp > min_timestamp and after > after_thresh and before > before_thresh:
            
            count = Counter(info['toll'])
            df = df_all[df_all['time_stamp']/1000 > (timestamp - 5)] # this gets the 5 seconds before the timestamp

            sampling_rate = 66.67 #readings per second
            df = df.head(int(120*sampling_rate)) #get next 120 seconds of readings..

            accelerometer_data = df.as_matrix(['acceleration_11lw_northside',
                              'acceleration_11lw_southside',
                              'acceleration_40lw_northside',
                              'acceleration_40lw_southside',
                              'displacement_40lw_northside',
                              'displacement_40lw_southside'])

            file_name = '{}_Clifton{}_Leigh{}_{}'.format(str(timestamp),           
                                                        count['Clifton'],
                                                        count['L.Woods'],
                                                        info['hour'])
            print(file_name)

            np.save(os.path.join(out_dir, file_name), accelerometer_data)

            # np.save(os.path.join('Data/Counts', str(timestamp)), count)

            del accelerometer_data
            del df

    del df_all
    gc.collect()

def loadFiles():
    # cannot load all data in so need to compare max and min dates in CSVs and then select appropriately

    with open('Data/csv_meta.json') as json_file:    
        csv_dict = json.load(json_file)

    with open('Data/toll_times.json') as json_file:    
        toll_dict = json.load(json_file)

    files = glob.glob('Structural Data/*.csv')

    for file in files:
        #file = 'Structural Data/CSBD_StructData_2017-02-14_Tue.csv'
        print('Processing {}'.format(file.split('/')[-1]))
        createData(file=file, toll_dict=toll_dict, max_timestamp=csv_dict[file.split('/')[-1]]['max'],
                   min_timestamp=csv_dict[file.split('/')[-1]]['min'])

def createDict():

    csv_dict = {}
    csv_files = glob.glob('Structural Data/*.csv')

    for file in csv_files:
        print('Processing {}'.format(file))
        df = pd.read_csv(file)
        min_timestamp = df.iloc[0]['time_stamp']/1000
        max_timestamp = df.iloc[-1]['time_stamp']/1000

        print(min_timestamp)

        csv_dict[file.split('/')[-1]] = {

            'min': min_timestamp,
            'max': max_timestamp 
        }

        del df
        gc.collect()

    with open('Data/csv_meta.json', 'w') as outfile:
        json.dump(csv_dict, outfile)

def countCarsFromTollData():

    pd.set_option('display.float_format', lambda x: '%.3f' % x)

    toll_file = 'Toll_barrier/Prox  comm 19-jan-2017.csv'
    print('Loading toll barrier data')
    toll_df = pd.read_csv(toll_file)
    toll_df = toll_df.drop_duplicates()
    #toll_df = toll_df.head(100)
    toll_df.columns = ['Date', 'Time', 'Toll', 'Lane', 'Card']
    toll_df['full_date'] = toll_df['Date'] + ' ' + toll_df['Time']
    toll_df['timestamp'] = pd.to_datetime(toll_df['full_date']).astype(int)/1000000000

    toll_df = toll_df[['Date', 'Time', 'Toll', 'Lane', 'Card', 'timestamp']]
    time_list = list(set(toll_df['timestamp'].tolist()))
    time_list.sort()

    time_dict = defaultdict(lambda: defaultdict(list))
    bar = Bar('Processing', max=len(toll_df))

    for ind, row in toll_df.iterrows():
        time_dict[str(row.timestamp)]['toll'].append(row.Toll)

        time_ind = time_list.index(row.timestamp)

        after = 0
        before = 0
        if time_ind > 0:
            after = row.timestamp - time_list[time_ind - 1]
        if time_ind < len(time_list)-1:
            before = time_list[time_ind + 1] - row.timestamp

        time_dict[str(row.timestamp)]['after'] = after
        time_dict[str(row.timestamp)]['before'] = before
        time_dict[str(row.timestamp)]['hour'] = row.Time
        
        bar.next()
    bar.finish()

    with open('Data/toll_times.json', 'w') as outfile:
        json.dump(time_dict, outfile)


def main():

    #countCarsFromTollData()
    #loadFiles()
    createMatFiles()
    #createDict()

if __name__ == '__main__':
    main()