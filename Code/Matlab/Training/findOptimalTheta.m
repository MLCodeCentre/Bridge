function findOptimalTheta

folder = 'both_1';
files = dir(fullfile(dataDir,'Test Samples',folder,'*.mat'));
num_files = size(files,1)
shuff = randperm(num_files);
files = files(shuff);
results = {};

thetas = zeros(num_files,5);

for file_num = 1:num_files
    
    close all
    
    file = files(file_num);
    file_name = file.name
    %file_name = '7.mat';
    full_file_name = fullfile(dataDir,'Test Samples',folder,file_name);
    file_load = load(full_file_name);
    responses = file_load.responses;
    reading = responses(:,4); % 40LW N
    
    
    %% preprocessing
    params = config();

    time = linspace(0, length(reading)/params.sampling_rate, length(reading));
    %plot(time, data_sample)
    scaled = normaliseSignal(reading);
    plot(time,scaled)
    window_size = 20;
    reading_envelope = moveRMS(scaled,window_size);
    offset = mean(reading_envelope(reading_envelope<0.01));
    reading_envelope = reading_envelope - offset;
    reading_envelope = reading_envelope';
    
    % finding theta
    plot(reading_envelope)
    fit = zeros(size(reading_envelope));
    [theta_solve, ~] = optimiseSkewedNormal(reading_envelope, time, fit);
    
    thetas(file_num,:) = theta_solve
end
