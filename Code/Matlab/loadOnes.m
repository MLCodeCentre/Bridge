function data = loadOnes

% Loads data from a folder of hand picked samples. All samples have one
% clear response 
% Outputs: 
%   data [N*D] double. N time series of length D loaded from folder

params = config();
file_dir = fullfile(rootDir(),'Data','September','threshold_3_total_1');
file_search = fullfile(file_dir,'*.mat');
files = dir(file_search);
%files = files(randperm(length(files)));
num_files = size(files,1);
data = zeros(num_files, 6000);

for file_ind = 1:num_files
    data_load = load(fullfile(file_dir,files(file_ind).name));
    data(file_ind,:) = data_load.responses(:,4)';
end
end % loadOnes