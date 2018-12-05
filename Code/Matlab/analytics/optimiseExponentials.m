function [theta, fit] = optimiseExponentials(data, t, n)

   
theta_0 = [];
LB = [];
UB = [];
for i = 1:n
    theta_0 =  [theta_0, 1,1,1,60];
    LB = [LB, 0, 0, 0.1, 0];
    UB = [UB, 10, 10, 100, 110];
end

%LB = [0, 0, 0.1, 0];
%UB = [10, 10, 100, 110];

f = @(theta) Exponentials(theta, t, data, n);
%[theta, theta_val] = lsqnonlin(f,theta_0,LB,UB)
%[theta, theta_val] = lsqcurvefit(f,theta_0,t,data,LB,UB)

disp('Running Global search')
problem = createOptimProblem('lsqnonlin','objective',f,'x0',theta_0,'xdata',t,'ydata',data,'lb',LB,'ub',UB);
ms = MultiStart;
[theta, theta_val] = run(ms,problem,10)

%fit = fit + genExp(t,theta);    
fit = f(theta);
end