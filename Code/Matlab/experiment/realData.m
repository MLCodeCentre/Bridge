function [data,t] = realData

t = linspace(0,120,8000);
barrier = 'LW'; total = '1'; threshold = '2';
folder = strcat([barrier,'_total_',total,'_threshold_',threshold]);
file_name = '7.mat';
file_load = load(fullfile(dataDir,folder,file_name));
responses = file_load.responses;
reading = responses(:,4); % 40LW N
scaled = normaliseSignal(reading);
window_size = 5;
reading_envolope = moveRMS(scaled,window_size);
data = reading_envolope - min(reading_envolope);
data = data';