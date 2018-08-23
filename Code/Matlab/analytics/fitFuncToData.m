function [optimal_fit, optimal_params] = fitFuncToData(data, time)

% fits N log normal functions to data using lsqcurve fit. Inits and
% boundary conditions are set in config. However the init tau is find from
% the max value of the residual. The optimal linear combination of fits and
% corresponding set of parameters are returned. 
% Inputs:
%   data [D] double. Data array of length D.
%   time [D] double. Corresponsding time array of length D.
% Outputs:
%   optimal_fit [D] double. Array of length D containing the optimal linear combination
%   of log normals.
%   optimal_params [N * 4] double. Array of N*4 parameters that describe
%   the optimal N log normals. 

params = config();
 
% instatiate the fit and errors
fit = zeros(size(data));
total_fit = fit;
fit_params = zeros(params.itters, 4);

% initial AIC calculation
k = 1;
n = length(data);
ll = logLikelihood(data, total_fit);
AICs = 2*k - 2*ll;
MSEs = sum(((data-total_fit).^2))/n;

figure;
for i = 1:params.itters
    % residual is the difference between the data and fit
    residual = data - total_fit; 
    % we begin our initial fitting at the maximum of stats
    %loc = find(residual == max(residual))/params.sampling_rate - params.offset;
    %loc = 16;
    
    %fitting the logNorm Function
    [fit_params_new, fit_new] = optimiseLogNorm(residual, time);
    fits{i} = fit_new;
    fit_params(i, :) = fit_params_new;
    
    % update total fit
    total_fit = total_fit + fit_new;
       
    % calculate AIC
    k = i*4;
    ll = logLikelihood(data, total_fit);
    AICs = [AICs, 2*k - 2*ll];
           
    MSEs = [MSEs, sum(((data-total_fit).^2))/n];
     
    % plot data and new fit
    subplot(params.itters, 2, 2*i - 1)
    plot(time, data);
    legendInfo{1} = 'Data';
    hold on
    for num_fit = 1:i
        plot(time, fits{num_fit})
        legendInfo{i+1} = strcat('Fit ',num2str(i));
    end
    %title(strcat('Fits=',num2str(i),':  MSE=',num2str(MSE)))
    legend(legendInfo,'Location','northwest')
    ylim([0,1])
end
xlabel('Time')
% plotting the AICs 
subplot(params.itters, 2, [2:2:2*i])
plot(0:params.itters, AICs)
set(gca,'xtick',0:params.itters)
set(gca,'xticklabel',0:params.itters)
xlabel('Number of fits')
ylabel('AIC')
title('Akaiake Information Criterion')

%finding optimal number of fits
AIC_min = max(1,(find(AICs == min(AICs))-1));
optimal_fit = fits{AIC_min};
%figure;
%plot(optimal_fit)
optimal_params = fit_params(1:AIC_min, :);

end %fitFuncToData.m
