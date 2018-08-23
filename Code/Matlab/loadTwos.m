function data = loadTwos

% Loads data from a folder of hand picked samples. All samples have one
% clear response 
% Outputs: 
%   data [N*D] double. N time series of length D loaded from folder

params = config();
file_search = fullfile(rootDir(),'Data','Clean Twos','120','60secs','*.mat');
files = dir(file_search);
files = files(randperm(length(files)));
num_files = size(files,1);

data = zeros(num_files, params.number_readings_per_minute);
for file_ind = 1:num_files
    data_load = load(files(file_ind).name);
    data(file_ind, :) = data_load.data;
end
end % loadTwos