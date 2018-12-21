function y = pointDiffusions(theta, t_range, data, fit)

y = fit + pointDiffusion(t_range,theta) - data;

end