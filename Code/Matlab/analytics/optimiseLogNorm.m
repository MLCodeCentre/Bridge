function [theta_solve, fit] = optimiseLogNorm(data, t, fit)

%
theta_0 =  [1,1,1,10,0];     

LB = [0, 0, 0, 0, 0];
UB = [3, 3,  2,  115, 0.05];

f = @(theta) logNorms(theta, t, data, fit);
%theta_solve = lsqnonlin(f,theta_0,LB,UB)
%[theta, theta_val] = lsqnonlin(f,theta_0,LB,UB)
%[theta, theta_val] = lsqcurvefit(f,theta_0,t,data,LB,UB)

disp('Running Global search')
problem = createOptimProblem('lsqnonlin','objective',f,'x0',theta_0,'xdata',t,'ydata',data,'lb',LB,'ub',UB);
ms = MultiStart;
[theta_solve, theta_val] = run(ms,problem,20)


fit = fit + logNorm(t,theta_solve);
%figure
%plot(t,data,t,fit)
end 