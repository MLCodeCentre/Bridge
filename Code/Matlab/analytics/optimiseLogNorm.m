function [fit_params, fit] = optimiseLogNorm(data, t)

% fits exponention function in genExp.m to data. 
% Inputs:
%    data [D] double. Data array of length D to be fit.
%    t [D] double. Corresponding time vector of length D.
% Outputs:
%    fit [D] double. Array of fit off optimised fit over time interval.
 % peak detection to place algorithm in roughly the right place
    params = config();
      
    lb = [0.1, 0.01, 0.1,  0];%,  0];
    ub = [2,   2,    4,    55];%, 0.1];
    x0 = [1.5, 0.05, 1,    30];%, 0.005];
    
    opts = optimoptions('lsqcurvefit','Display','iter');
    problem = createOptimProblem('lsqcurvefit','x0',x0,'objective',@logNorm,...
    'lb',lb,'ub',ub, ...
    'xdata',t,'ydata',data, ...
    'options', opts);
    
    ms = MultiStart();%'PlotFcns',@gsplotbestf);
    [fit_params,fval,exitflag,output,solutions] = run(ms,problem,5);
    %plot(t, logNorm(coefEsts,t))
    
    fit = logNorm(fit_params, t);
    
end %fitExp