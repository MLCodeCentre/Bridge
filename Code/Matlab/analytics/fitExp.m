function [exp_params, fit] = fitExp(data, time, loc)

% fits exponention function in genExp.m to data. 
% Inputs:
%    data [D] double. Data array of length D to be fit.
%    time [D] double. Corresponding time vector of length D.
% Outputs:
%    fit [D] double. Array of fit off optimised fit over time interval.
    
    params = config();
    options = optimoptions('lsqcurvefit','OptimalityTolerance', 1e-16, 'FunctionTolerance', 1e-6);
    exp_params = lsqcurvefit(@genExp, [params.exp_params0, loc], time, data)%, params.exp_lower_bounds, params.exp_upper_bounds, options);
    
    fit = genExp(exp_params, time);
end %fitExp