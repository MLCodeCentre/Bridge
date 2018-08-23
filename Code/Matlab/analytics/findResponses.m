function vehicles = findResponses(data)

% Finds windows of fixed size of the Accelerometer Response that fit the Equation with
% parameters A, B defined in config. The measure of fit is the euclidean
% distance for the windowed data and the Heat Equation. Windows below a
% threshold specified in config define an accelerometer response to a vehicle. 
% Inputs:
%   data [D] double a time series of length D of the accelerometer
%   response.
% Outputs:
%   vehicles [N] the indices in data of where a vehicle is found.

close all
params = config();
% load the average fit of the Heat Equation.
window_size = ceil(params.window_time * params.sampling_rate);
heat_time = linspace(0, params.window_time, window_size);
k = heatEquation([params.heat_params], heat_time);

figure;
subplot(2,1,1)
hold on
errors = [];
vehicles = [];
% slide window across and fit Heat Equation
for ind = 1:length(data)-window_size
    window_data = data(ind:ind+window_size-1);
    error = norm(window_data - k);
    errors = [errors, error];
    if error < params.error_threshold
        if isempty(vehicles) == 0 && (ind - vehicles(end))/params.sampling_rate > params.error_gap
            vehicles = [vehicles, ind];
            vehicle_time = linspace(ind/params.sampling_rate, (ind+window_size)/params.sampling_rate, window_size);
            plot(vehicle_time, k, 'r')
        elseif isempty(vehicles) == 1
            vehicles = [vehicles, ind];
            vehicle_time = linspace(ind/params.sampling_rate, (ind+window_size)/params.sampling_rate, window_size);
            plot(vehicle_time, k, 'r')
        end
    end
    
end

% plot results
data_time = linspace(0, length(data)/params.sampling_rate, length(data));
plot(data_time, data)
ylabel({'Accelerometer Response', 'Variance'})

subplot(2,1,2)
error_time = linspace(0, length(errors)/params.sampling_rate, length(errors));
plot(error_time, errors)
ylabel('Error')
xlabel('Time')
   
end
