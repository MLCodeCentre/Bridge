function y = logNormsAR(theta, t_range, data, fit)

t = t_range(2:end);
t_minus1 = t_range(1:end-1);

data_t = data(2:end);
data_t_minus1 = data(1:end-1);

p = theta(end);
theta = theta(1:end-1);

y = fit(2:end) + (data_t - logNorm(t,theta)) - p*(data_t_minus1 - logNorm(t_minus1,theta));
 
end