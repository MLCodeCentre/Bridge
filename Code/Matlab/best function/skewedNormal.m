function y = skewedNormal(t_range,theta)

% location = theta(1);
alpha = theta(1);
delta = theta(2);
xi = 0;
lambda = 100;

gamma = theta(3);
tau = theta(4);
%t_star = theta(7);

% gaussian = @(x) (1/sqrt((2*pi))*exp(-x.^2/2));
% skewedgaussian = @(x,alpha) 2*gaussian(x).*normcdf(alpha*x);

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    t = t-tau/lambda;
    if t >= tau
        y(t_ind) = gamma*(alpha + delta*asinh(((t-tau)-xi)/lambda));
    else
        y(t_ind) = 0;
    end
end
