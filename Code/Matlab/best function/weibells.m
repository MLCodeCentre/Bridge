function y = weibells(theta, t_range, data, fit)

y = (fit + weibellFit(t_range,theta)) - data;

end
