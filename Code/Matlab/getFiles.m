function files = getFiles(num_Clifton, num_Leigh)

file_search = fullfile(rootDir(), 'Data', strcat('Clifton_', num2str(num_Clifton), ...
                              ' Leigh_', num2str(num_Leigh), '/*.mat'));
files = dir(file_search);

end