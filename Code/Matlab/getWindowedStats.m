function stats = getWindowedStats(data, window_size)

% returns the windowed statistics for the time series in data. 
% Inputs:
%   data [1xD] double. Time series of length D.
%   window_size int. The length of the window for which the statistics are
%   calculated.
% Outputs:
%   stats [1xD] double. Array of D windowed stats.

stats = zeros(1,size(data,2));

for ind = (1+window_size):(size(data,2)-window_size)
    
    window_data = data(ind-window_size: ind+window_size);
    stats(ind) = std(window_data);
end

stats = (stats - min(stats))/(max(stats) - min(stats));

end %getWindowedStats

