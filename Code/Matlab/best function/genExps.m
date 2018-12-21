function y = genExps(theta, t_range, data, fit)

y = fit + genExp(t_range,theta) - data;

end