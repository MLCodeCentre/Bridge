function [theta_solve, fit] = optimiseSkewedNormal(data, t, fit)

%
theta_0 =  [0,0,0,10];     

LB = [-5, -5, 0, 0];
UB = [5,   5, 2,  110];

f = @(theta) skewedNormals(theta, t, data, fit);
%theta_solve = lsqnonlin(f,theta_0,LB,UB)
%[theta, theta_val] = lsqnonlin(f,theta_0,LB,UB)
%[theta, theta_val] = lsqcurvefit(f,theta_0,t,data,LB,UB)

disp('Running Global search')
problem = createOptimProblem('lsqnonlin','objective',f,'x0',theta_0,'xdata',t,'ydata',data,'lb',LB,'ub',UB);
ms = MultiStart;
[theta_solve, theta_val] = run(ms,problem,5)


fit = fit + skewedNormal(t,theta_solve);
figure
plot(t,data,t,fit)
end 