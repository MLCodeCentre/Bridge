function main()

close all;
params = config();

data = loadOnes();
%data = loadTwos();

num_data = size(data,1);

for data_num = 1:1
    data_sample = data(27,:);
    time = linspace(0, length(data_sample)/params.sampling_rate, length(data_sample));
    %plot(time, data_sample)
    scaled = normaliseSignal(data_sample);
    plot(time,scaled)
    envolope = getSignalEnvolope(scaled);
    hold on
    plot(time,envolope)
    %[~, fit_params] = fitFuncToData(stats, time);
    %fit_params

end