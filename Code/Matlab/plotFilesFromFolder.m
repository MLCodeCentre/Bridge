function plotFilesFromFolder(num_Clifton, num_Leigh, num_plots)

% loops through all files in correct folder and plots them
% Inputs: 
%    num_Clifton, Int. Number of cars passing through Clifton toll in
%    a minute.
%    num_Leigh, Int. Number of cars passing through Leigh Woods toll in
%    a minute.
%    num_plots, Int. Number of figures to create

if ~exist('num_plots', 'var')
    num_plots = 1;
end

close all
% find correct data files from num_Clifton and num_Leigh
time='60';
file_search = fullfile(rootDir(), 'Data', time, strcat('Clifton_', num2str(num_Clifton), ...
                              ' Leigh_', num2str(num_Leigh), '/*.mat'));
files = dir(file_search);
% shuffle files so you don't get the same plots each time it's called. 
files = files(randperm(numel(files))); 
num_files = size(files, 1);

% loop though files and plot
plots = 0;
for file_num = 1:num_files
    if plots < num_plots
        file = files(file_num);
        plot4L(file.name, num_Clifton, num_Leigh)
        plots = plots + 1;
        if plots < num_plots
            figure;
        end
    end
end

end % plotFilesFromFolder()