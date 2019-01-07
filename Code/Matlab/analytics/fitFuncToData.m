function [num_vehicles,pcaf,logLqs] = fitFuncToData(data, time)

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
p = 4;
thresh = 0.1;
q = 8;
% initial AIC calculation
e = data-fit;
Rs(1) = sum(e.^2);
m = length(data);
N = 3;
fit_params = zeros(N, p);
[~,logL] = ARlogL(e,q,data,thresh);
logLs(1) = logL;
logLqs = zeros(N,q);

for n = 1:N
    % residual is the difference between the data and fit
    % we begin our initial fitting at the maximum of stats

    %fitting the logNorm Function
    [fit_params_new, fit] = optimiseLogNorm(data, time, fit);
    %[fit_params_new, fit] = optimiseSkewedNormal(data, time, fit);
    fits{n} = fit;
    fit_params(n,:) = fit_params_new(1:p);
    
    e = data-fit;
    R = sum((data-fit).^2);
    Rs(n+1) = R;
    
    % THIS IS NEW!! USING AN AR LIKELIHOOD. 
%     for Q = 1:q
%         [~,logL,~,~] = ARlogL(e,Q,data,thresh);
%         logLqs(n,Q) = logL; 
%     end
    [~,logL,~,pcaf] = ARlogL(e,q,data,thresh);
    logLs(n+1) = logL;                  
    % plot data and new fit
    subplot(N, 1, n)
    plot(time, data);
    hold on
    plot(time, fit);
    leg = legend('IAE',sprintf('$f_%d(t)$',n),'Location','northeast'); 
    leg.FontSize = 11;
    set(leg, 'Interpreter', 'latex')
    xlabel('t [s]')
    ylabel('Acceleration [ms^{-2}]')
    
end
K = [1,(1:N)*p];
[aics, bics] = aicbic(logLs,K,m);
%aics = [aics,aic]; bics = [bics,bic]; 
aics

% figure;
% plot(time, data);
% hold on
% plot(time, fit);
% leg = legend('IAE',sprintf('$f_%d(t)$',n),'Location','northeast');
% set(leg, 'Interpreter', 'latex')
% xlabel('t [s]')
% ylabel('Acceleration [ms^{-2}]')

figure;
% xlabel('Time')
% plotting the AICs 
yyaxis right
plot(0:N, aics,'--*')
ylabel('AIC')

xlabel('Number of Vehicles')
set(gca,'xtick',0:N)
set(gca,'xticklabel',0:N)

%title('Akaike Information Criterion')

% plotting the AICs 
yyaxis left
plot(0:N, Rs,'--*')
ylabel('Sum Squared Error [ms^{-2}]')
leg.FontSize = 11;
grid on;
% set(gca,'xtick',1:N)
% set(gca,'xticklabel',1:N)

%title('Sum Square Error')

%finding optimal number of fits
%AIC_min = max(1,(find(AICs == max(AICs))-1));
aic_min = find(aics == min(aics));
%optimal_fit = fits{aic_min};
%figure;
%plot(optimal_fit)
%optimal_params = fit_params(1:aic_min, :);
num_vehicles = aic_min-1;

end %fitFuncToData.m