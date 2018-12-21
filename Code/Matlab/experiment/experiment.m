function experiment

close all
[data,t] = realData();
plot(t,data)
figure
m = 8000;
q = 10;
thresh = 0.1;
%% fitting to the data
fit = zeros(size(t));
e = data-fit;
r = sum(e.^2); rs(1) = r;
[~,logL,e_hat_res] = ARlogL(e,q,data,thresh);
e_hat_rs(1) = e_hat_res;
logLs(1) = logL;
%es = data - fit;
p = 50;
N = 3;
f = [];
for n = 1:N
    %[fit_params_new, fit] = optimiseNlogNorms(data, t, n);
    %[fit_params_new, fit] = optimiseGenExp(data, t, fit);
    %[fit_params_new, fit] = optimiseGammaFit(data, t, fit);
    %[fit_params_new, fit] = optimiseDiffusion(data, t, fit);
    [fit_params_new, fit] = optimiseLogNorm(data, t, fit);
    fit_params_new
    e = data-fit;
    r = sum(e.^2); rs(n+1) = r;
    
    [~,logL,e_hat_res] = ARlogL(e,q,data,thresh);
    e_hat_rs(n+1) = e_hat_res;
    
    logLs(n+1) = logL;
    subplot(N,1,n)
    plot(t,data,t,fit)
        
end
figure
K = [1,(1:N).*p;];
%logLs
[aics, bics] = aicbic(logLs,K,m);
aics
rs
e_hat_rs
subplot(2,1,1)
plot(aics,'b-*')
ylabel('AIC')
subplot(2,1,2)
plot(rs,'r-*')
ylabel('Sum Square Error')

num_vehicles = find(aics == min(aics)) - 1

end


