function [AIC_min,pcaf,logLqs] = main(reading)

close all;
params = config();

time = linspace(0, length(reading)/params.sampling_rate, length(reading));
%plot(time, data_sample)
scaled = normaliseSignal(reading);
plot(time,scaled)
window_size = 20;
reading_envolope = moveRMS(scaled,window_size);
offset = max(reading_envolope(reading_envolope<0.01))
reading_envolope = reading_envolope - offset;
hold on
plot(time,reading_envolope)
xlabel('Time [s]')
ylabel('Acceleration [ms^{-2}]')

[AIC_min,pcaf,logLqs] = fitFuncToData(reading_envolope', time);
%fit_params
