function createStatFiles

time_thresholds = {'60', '120', '240', '360'};
num_time_thresholds = numel(time_thresholds);
for threshold_num = 1:num_time_thresholds
    files = dir(fullfile(rootDir(), 'Data', 'Accelerometer Responses',...
                time_thresholds{threshold_num}, '*.mat'));
    num_files = numel(files);
    for file_num = 1:num_files
        disp(files(file_num).name)
    end
end

end %creatStatFiles