function [window_data, window_time] = getEventWindow(data)

% Finds events in time series. Events are defined as peaks which are found
% my findPeaks with Min Peak Distance and Height defined in config.m.
% Currently only the first peak is returned as the aim is to profile
% One peak.
% Inputs: 
%   data [D] double. Array of length D time series.
% Outputs: 
%   window_data [W] double. Array of length W time series.
%   The window size W is defined by the parameters window_before and
%   window_after in config.m.
%   winow_time [W] double. Array of corresponding time values of window         

params = config();

[pks,locs] = findpeaks(data, 'MinPeakDistance', params.min_peak_distance*params.sampling_rate,...
                             'MinPeakHeight', params.min_peak_height);
if isempty(locs)
    window_data = [];
    window_time = [];
else
    ind_before = max(0,locs(1) - params.window_before*params.sampling_rate);
    ind_after = min(locs(1) + params.window_after*params.sampling_rate, params.number_readings_per_minute);
    window_data = data(ind_before : ind_after);

    window_time = linspace(0, params.window_after - params.window_before, length(window_data));
end

end %getEventWindow