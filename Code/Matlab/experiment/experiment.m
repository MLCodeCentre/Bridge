function experiment

close all
[data,t] = realData();
plot(t,data)
figure
m = 8000;
%% fitting to the data
fit = zeros(size(t));
e = data-fit;
e_fit = e(data>0.05);
r = sum(e_fit.^2); rs(1) = r;
model = arima(2,0,2);
[mod,~,logL] = estimate(model,e_fit');
logLs(1) = logL
%es = data - fit;
p = 5;
N = 2;
f = [];
for n = 1:N
    [fit_params_new, fit] = optimiseLogNorm(data, t, fit);
    e = data-fit;
    e_fit = e(data>0.05);
    r = sum(e_fit.^2); rs(n+1) = r;
    model = arima(2,0,2);
    [mod,~,logL] = estimate(model,e_fit');
    %logL = garchLogL(e,0,1);
    logLs(n+1) = logL
    subplot(N,1,n)
    plot(t,data,t,fit)
        
end
figure
K = [1,(1:N).*p;];
%logLs
[aics, bics] = aicbic(logLs,K,m);
aics
rs
subplot(2,1,1)
plot(aics,'b-*')
subplot(2,1,2)
plot(rs,'r-*')

end
