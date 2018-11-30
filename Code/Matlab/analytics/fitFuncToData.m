function [optimal_fit, optimal_params, num_vehicles] = fitFuncToData(data, time)

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
% num of params
p = 5;
fit_params = zeros(params.itters, p);

% initial AIC calculation
e = data-fit;
m = length(data);

logLs = [];
Rs = [];
N = 3;
for n = 1:N
    % residual is the difference between the data and fit
    % we begin our initial fitting at the maximum of stats

    %fitting the logNorm Function
    [fit_params_new, fit] = optimiseLogNorm(data, time, fit);
    fits{n} = fit;
    fit_params(n,:) = fit_params_new;
    
    e = data-fit;
    R = sum((data-fit).^2);
    Rs = [Rs, R];
    
    % THIS IS NEW!! USING A GARCH LIKELIHOOD. 
    logL = garchLogL(e);
    logLs = [logLs, logL];                  
    % plot data and new fit
    subplot(params.itters, 1, n)
    plot(time, data);
    hold on
    plot(time, fit);
    legend('Data',sprintf('Fit %d',n),'Location','northeast'); 
    
end
K = [(1:N)*p];
[aics, bics] = aicbic(logLs,K,m);
%aics = [aics,aic]; bics = [bics,bic]; 
aics

figure;
subplot(2,1,1)
% xlabel('Time')
% plotting the AICs 
plot(1:N, aics)
set(gca,'xtick',1:N)
set(gca,'xticklabel',1:N)
xlabel('Number of Vechiles')
ylabel('AIC')
title('Akaike Information Criterion')

subplot(2,1,2)
% plotting the AICs 
plot(1:N, Rs)
set(gca,'xtick',1:N)
set(gca,'xticklabel',1:N)
xlabel('Number of Vechiles')
ylabel('Sum Squared Error')
title('Sum Square Error')

%finding optimal number of fits
%AIC_min = max(1,(find(AICs == max(AICs))-1));
aic_min = find(aics == min(aics));
optimal_fit = fits{aic_min};
%figure;
%plot(optimal_fit)
optimal_params = fit_params(1:aic_min, :);
num_vehicles = aic_min;

end %fitFuncToData.m