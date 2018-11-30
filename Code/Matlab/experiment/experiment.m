function experiment 
close all

%% simulating data 
m = 800;
p = 4;
t = linspace(0,120,m);

%2 lognorms
mu_1 = 1; sigma_1 = 0.5; gamma_1 = 1; tau_1 = 20; t_star_1 = 0;
theta_1 = [mu_1, sigma_1, gamma_1, tau_1, t_star_1];

mu_2 = 2; sigma_2 = 0.1; gamma_2 = 2; tau_2 = 65; t_star_2 = 0;
theta_2 = [mu_2, sigma_2, gamma_2, tau_2, t_star_2];

mu_3 = 1.5; sigma_3 = 1; gamma_3 = 1.4; tau_3 = 80; t_star_3 = 0;
theta_3 = [mu_3, sigma_3, gamma_3, tau_3, t_star_3];

%noise
noise = 0 + 0.005.*randn(size(t));
%data = t.^2.*exp(-t);
data = logNorm(t,theta_1) + logNorm(t,theta_2) + logNorm(t,theta_3) + noise;

plot(t,data)
hold on

%% fitting to the data
fit = zeros(size(t));
%es = data - fit;
rs = [];
logLs = [];
N = 5;
for n = 1:N
    [fit_params_new, fit] = optimiseLogNorm(data, t, fit);
    e = data-fit;
    r = sum(e.^2); rs = [rs, r];
    logL = garchLogL(e);
    logLs = [logLs, logL];
  
end

plot(t,fit)

K = [(1:N)*p + 1];
logLs
[aics, bics] = aicbic(logLs,K,m);
aics
rs
figure
plot(aics,'b-*')
%plot(rs)

end

function sigma_t = sigmaT(sigma,e,p,q)
    
    p = min(p,length(sigma));
    q = min(q,length(e));
    
    k = 0.1; 
    alpha=(0.2/p)*ones(1,p);
    beta=(0.2/q)*ones(1,q);
  
    % see matlab on conditional variance model for more info on this:
    sigma_t = k + sum(alpha.*sigma(end-p+1:end)) + sum(beta.*e(end-q+1:end));

end
