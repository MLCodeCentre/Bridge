function [reading_envolope,t] = realData

t = linspace(0,120,8000);
barrier = 'Clifton'; total = '1'; threshold = '2';
folder = strcat([barrier,'_total_',total,'_threshold_',threshold]);
file_name = '10.mat';
file_load = load(fullfile(dataDir,folder,file_name));
responses = file_load.responses;
reading = responses(:,4); % 40LW N
scaled = normaliseSignal(reading);
plot(t,scaled)
window_size = 5;
reading_envolope = moveRMS(scaled,window_size);
offset = mean(reading_envolope(reading_envolope<0.01))
reading_envolope = reading_envolope - offset;

reading_envolope = reading_envolope';