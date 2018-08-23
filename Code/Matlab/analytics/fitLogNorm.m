function [exp_params, fit] = fitLogNorm(data, t, loc)

% fits exponention function in genExp.m to data. 
% Inputs:
%    data [D] double. Data array of length D to be fit.
%    t [D] double. Corresponding time vector of length D.
% Outputs:
%    fit [D] double. Array of fit off optimised fit over time interval.
 % peak detection to place algorithm in roughly the right place
    params = config();
      
    options = optimoptions('lsqcurvefit','OptimalityTolerance', 1e-16, 'FunctionTolerance', 1e-6);
    exp_params = lsqcurvefit(@logNorm, [params.ln_params0, loc], t, data, params.ln_lower_bounds, params.ln_upper_bounds, options);
    fit = logNorm(exp_params, t);
    fit = fit + params.x_star;
end %fitExp