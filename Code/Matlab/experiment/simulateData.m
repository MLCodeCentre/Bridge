function [data, t] = simulateData(m)

%% simulating data 
m = 8000;
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
model = arima('Constant',0.01,'AR',{0.7},'Variance',.0005);
noise = simulate(model,m)';
%data = genExp(t,[1,1,1,10]);
data = logNorm(t,theta_2) + noise;