function experiment 
close all

%% simulating data 
m = 800;
p = 5;
t = linspace(0,120,m);

%2 lognorms
mu_1 = 1; sigma_1 = 0.5; gamma_1 = 1; tau_1 = 20; t_star_1 = 0;
theta_1 = [mu_1, sigma_1, gamma_1, tau_1, t_star_1];

mu_2 = 2; sigma_2 = 0.1; gamma_2 = 2; tau_2 = 65; t_star_2 = 0;
theta_2 = [mu_2, sigma_2, gamma_2, tau_2, t_star_2];

mu_3 = 1.5; sigma_3 = 1; gamma_3 = 1.4; tau_3 = 80; t_star_3 = 0;
theta_3 = [mu_3, sigma_3, gamma_3, tau_3, t_star_3];

%noise
noise = 0 + 0.02.*randn(size(t));
%data = genExp(t,[1,1,1,10]);
data = logNorm(t,theta_2) + logNorm(t,theta_3) + noise;

plot(t,data)
figure

%% fitting to the data
fit = zeros(size(t));
e = data-fit;
r = sum(e.^2); rs(1) = r;
%es = data - fit;
N = 5;
f = [];
for n = 1:N
    [fit_params_new, fit] = optimiseLogNorm(data, t, fit);
    e = data-fit;
    
    r = sum(e.^2); rs(n+1) = r;
    %logL = garchLogL(e,0,1);
    %logLs(n) = logL
    subplot(N,1,n)
    plot(t,data,t,fit)
    
    ss1 = rs(n); p1 = (n-1)*p;
    ss2 = rs(n+1); p2 = n*p;
    
    f(n) = (ss1 - ss2)/(p2 - p1)...
         /(ss2/(m-p2));
        
end
figure
plot(1:N,f)
hold on
plot(1:N,0.05*ones(size(f)))

%logLs
%[aics, bics] = aicbic(logLs,K,m);
aics
rs
figure;
%plot(aics,'b-*')
%plot(rs)

end
