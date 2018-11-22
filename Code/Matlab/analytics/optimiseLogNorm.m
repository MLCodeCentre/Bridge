function [theta, fit] = optimiseLogNorm(data, t, fit)

params = config();

theta_0 =  [0,1,1,60,0.01];     

LB = [0, 0, 0.1, 0, 0];
UB = [10, 10, 10, 110, 0.1];


f = @(t,theta) logNorms(t, theta, fit);
[theta, theta_val] = lsqcurvefit(f,theta_0,t,data,LB,UB)

% disp('Running Global search')
problem = createOptimProblem('lsqcurvefit','objective',f,'x0',theta_0,'xdata',t,'ydata',data,'lb',LB,'ub',UB);
ms = MultiStart();
[theta, theta_val] = run(ms,problem,10)

fit = fit + logNorm(t,theta);    

end 