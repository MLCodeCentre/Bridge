function y = gammaFits(theta, t_range, data, fit)

y = fit + gammaFit(t_range,theta) - data;

end