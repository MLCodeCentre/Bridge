function y = skewedNormals(theta, t_range, data, fit)

y = (fit + skewedNormal(t_range,theta)) - data;

end
