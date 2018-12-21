function [theta, fit] = optimiseDiffusion(data, t, fit)

%
theta_0 =  [1,1,1,1,1];     

LB = [1, 1, 1, 1, 0];
UB = [2, 2, 100, 110, 0.2];

f = @(theta) pointDiffusions(theta, t, data, fit);
%[theta, theta_val] = lsqnonlin(f,theta_0,LB,UB)
%[theta, theta_val] = lsqcurvefit(f,theta_0,t,data,LB,UB)

disp('Running Global search')
problem = createOptimProblem('lsqnonlin','objective',f,'x0',theta_0,'xdata',t,'ydata',data,'lb',LB,'ub',UB);
ms = MultiStart;
[theta, theta_val] = run(ms,problem,10)


fit = fit + pointDiffusion(t,theta);    

end 