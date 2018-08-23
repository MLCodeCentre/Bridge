function data = loadData()

params = config();
file_search = fullfile(rootDir(),'Data','Accelerometer Responses',params.file_thresh,'*.mat');
files = dir(file_search);
%shuffle
files = files(randperm(length(files)));
%num_files = length(files);
data = zeros(params.num_files, params.data_length);
for file_num = 1:params.num_files
    data_load = load(files(file_num).name);
    data(file_num, :) = data_load.data(:,2);
end