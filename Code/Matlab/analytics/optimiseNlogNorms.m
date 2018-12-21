function [theta, fit] = optimiseNlogNorms(data, t, N)

theta0 = [];
LB = [];
UB = [];
for n = 1:N
    theta0 =  [theta0, 0,1,1,60,0];
    LB = [LB, 0, 0, 0.1, 0, 0];
    UB = [UB, 10, 10, 10, 110, 0.2];
end

f = @(theta,t) NlogNorms(t, theta, N);
%[theta, theta_val] = lsqnonlin(f,theta_0,LB,UB)
%[theta, theta_val] = lsqcurvefit(f,theta_0,t,data,LB,UB)

disp('Running Global search')
problem = createOptimProblem('lsqcurvefit','objective',f,'x0',theta0,'xdata',t,'ydata',data,'lb',LB,'ub',UB);
ms = MultiStart;
[theta, theta_val] = run(ms,problem,5);


fit = f(theta,t);  

end 