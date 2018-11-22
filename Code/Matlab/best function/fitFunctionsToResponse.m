function [fit_params,resnorm] = fitFunctionsToResponse(response,function_type)

%close all

response = response - mean(response);
response = normaliseSignal(response);
envelope = moveRMS(response,5)';

sampling_rate = 66.67;
t = linspace(0, length(envelope)/sampling_rate, length(envelope));

% considers a set of functions and fits the best akaike.

if strcmp(function_type,'LogNormal')
    lb = [0, 0, 0, 0];
    ub = [100, 100, 10, 120];
    x0 = [1, 1, 0.5, 1];

    f = @logNorm;

elseif strcmp(function_type,'Exp')
    lb = [-5, -5, 0, 0];
    ub = [5, 5, 10, 120];
    x0 = [1, 1, 0.5, 60];

    f = @genExp;

elseif strcmp(function_type,'Gamma')
    lb = [0,0,0,0];
    ub = [10,10,10,120];
    x0 = [1,1,0.5,60];   
    
    f = @gammaFit;
    
elseif strcmp(function_type,'Weibell')
    lb = [0,0,0,0];
    ub = [10,10,10,120];
    x0 = [1,1,0.5,60];   
    
    f = @weibellFit;
    
end

opts = optimset('Display','off');
[fit_params,resnorm,~,exitflag,output] = lsqcurvefit(f,x0,t,envelope,lb,ub,opts);

% figure;
%plot(t, envelope)
%hold on
%plot(t, f(fit_params,t))