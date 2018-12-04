function getResults(i)
close all
% Analyse ones 
barrier = 'LW'; total = '1'; threshold = '2';
folder = strcat([barrier,'_total_',total,'_threshold_',threshold]);

files = dir(fullfile(dataDir,folder,'*.mat'));
num_files = size(files,1);
%shuff = randperm(num_files);
%files = files(shuff);


for file_num = i:num_files
    file = files(file_num);
    file_name = file.name
    %file_name = '7.mat';
    file_load = load(fullfile(dataDir,folder,file_name));
    responses = file_load.responses;
    response = responses(:,4); % 40LW N
    %plot(response)
    num_vehicles = main(response)
end

end

