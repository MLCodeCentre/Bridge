function AIC_min = main(reading)

close all;
params = config();

time = linspace(0, length(reading)/params.sampling_rate, length(reading));
%plot(time, data_sample)
scaled = normaliseSignal(reading);
plot(time,scaled)
window_size = 20;
reading_envolope = moveRMS(scaled,window_size);
reading_envolope = reading_envolope - min(reading_envolope);
hold on
plot(time,reading_envolope)

[~, ~, AIC_min] = fitFuncToData(reading_envolope', time);
%fit_params
