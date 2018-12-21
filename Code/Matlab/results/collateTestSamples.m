function collateTestSamples(barrier,total,threshold)
% Analyse ones 
barrier = num2str(barrier); total = num2str(total); threshold = num2str(threshold);
folder = strcat([barrier,'_total_',total,'_threshold_',threshold]);

files = dir(fullfile(dataDir,folder,'*.mat'));
num_files = size(files,1);
shuff = randperm(num_files);
files = files(shuff);
results = {};

for file_num = 1:num_files
    
    close all
    
    file = files(file_num);
    file_name = file.name
    %file_name = '7.mat';
    full_file_name = fullfile(dataDir,folder,file_name);
    file_load = load(full_file_name);
    responses = file_load.responses;
    response = responses(:,4); % 40LW N
    plot(response)
    
    label = input('How many vehicles does it look like there are?')
    
    if label > 0
        out_file_name = strcat([barrier,'_',num2str(label)]);
        out_file = fullfile(dataDir,'Test Samples',out_file_name,file_name);
        save(out_file,'responses');
    end
end

end