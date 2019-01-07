function [theta_solve,fit] = optimiseFit(fit_type,data,t,fit)

    switch fit_type
        case 'logNorm'
            theta_0 =  [1,1,1,10,0];     
            lb = [0, 0, 0, 0, 0];
            ub = [3, 3,  2,  115, 0.001];

            f = @(theta) logNorms(theta, t, data, fit);
            fit_func = @(theta) logNorm(t, theta);
        case 'weibull'
            theta_0 =  [1,1,1,60,0]; 
            lb = [0,   0,    0.1,   5,   0];
            ub = [20, 20,    2,     115, 0.005];

            f = @(theta) weibells(theta, t, data, fit);
            fit_func = @(theta) weibellFit(t, theta);
        otherwise
            fprintf('%s not valid',fit_type)
    end
    
    problem = createOptimProblem('lsqnonlin','x0',theta_0,'objective',f,...
    'lb',lb,'ub',ub,'xdata',t,'ydata',data);
  
    ms = MultiStart();
    [theta_solve,f_val] = run(ms,problem,20);
    
    fit = fit + fit_func(theta_solve);       

end