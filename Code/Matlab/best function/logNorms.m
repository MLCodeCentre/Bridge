function y = logNorms(theta, t_range, data, fit)

y = (fit + logNorm(t_range,theta)) - data;

end
