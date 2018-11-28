function [optimal_fit, optimal_params, AIC_max] = fitFuncToData(data, time)

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
Rs = sum((data-fit).^2);
lls = -(m/2)*log(Rs);

lambda = [0.1, min(e)];
e_lambda = boxCorrection(e,lambda);
e_lambda_bar = mean(e_lambda);
ll_boxes = -(m/2)*log((sum(e_lambda-e_lambda_bar).^2)/m) + (lambda-1)*sum(log(Rs));
%k = 1;
%[aics, bics] = aicbic(lls,k,m);

% perform fits
figure;
N = params.itters;
for n = 1:N
    % residual is the difference between the data and fit
    % we begin our initial fitting at the maximum of stats

    %fitting the logNorm Function
    [fit_params_new, fit] = optimiseLogNorm(data, time, fit);
    %fits{n} = fit;
    fit_params(n,:) = fit_params_new;
    
    e = data-fit;
    R = sum((data-fit).^2);
    Rs = [Rs, R];
    % calculate AIC
    %ll = -(m/2)*log(R/m);
    e = (data-fit);
    sigma = sqrt(std(e));
    ll = sum(log(normpdf(e,0,sigma)));
    lls = [lls,ll];
    
    lambda = [0.1,min(e)];
    e_lambda = boxCorrection(e,lambda);
    e_lambda_bar = mean(e_lambda);
    ll_box = -(m/2)*log((sum(e_lambda-e_lambda_bar).^2)/m) + (lambda-1)*sum(log(R));
    ll_boxes = [ll_boxes, ll_box];
    
    
                      
    % plot data and new fit
    subplot(params.itters, 1, n)
    plot(time, data);
    hold on
    plot(time, fit);
    legend('Data',sprintf('Fit %d',n),'Location','northeast'); 
end
K = [1,(1:N)*p + 1];
[aics, bics] = aicbic(lls,K,m);
%aics = [aics,aic]; bics = [bics,bic]; 

figure;
subplot(2,1,1)
% xlabel('Time')
% plotting the AICs 
plot(0:params.itters, aics)
set(gca,'xtick',0:params.itters)
set(gca,'xticklabel',0:params.itters)
xlabel('Number of Vechiles')
ylabel('AIC')
title('Akaike Information Criterion')

subplot(2,1,2)
% plotting the AICs 
plot(0:params.itters, Rs)
set(gca,'xtick',0:params.itters)
set(gca,'xticklabel',0:params.itters)
xlabel('Number of Vechiles')
ylabel('Sum Squared Error')
title('Sum Square Error')

%finding optimal number of fits
%AIC_min = max(1,(find(AICs == max(AICs))-1));
AIC_max = find(AICs == max(AICs))-1;
optimal_fit = fits{AIC_max};
%figure;
%plot(optimal_fit)
optimal_params = fit_params(1:AIC_max, :);


Rs
fit_params
MCps

end %fitFuncToData.m

function y = boxCorrection(x,lambda)
    x_size = length(x);
    y = zeros(1,x_size);
    for i = 1:x_size
        if lambda(1) == 0
           y(i) = log(x(i)+lambda(2)); 
        else
           y(i) = ((x(i)+lambda(2)^lambda(1) - 1))/lambda(1); 
        end
    end
end