function [theta, fit] = optimiseGenExp(data, t, fit)

theta_0 =  [0,1,1,60,0];     

LB = [0, 0, 0.1, 0, 0];
UB = [10, 10, 10, 110, 0];

f = @(theta) genExps(theta, t, data, fit);
%[theta, theta_val] = lsqnonlin(f,theta_0,LB,UB)
%[theta, theta_val] = lsqcurvefit(f,theta_0,t,data,LB,UB)

disp('Running Global search')
problem = createOptimProblem('lsqnonlin','objective',f,'x0',theta_0,'xdata',t,'ydata',data,'lb',LB,'ub',UB);
ms = MultiStart;
[theta, theta_val] = run(ms,problem,10);


fit = fit + logNorm(t,theta);    

end 