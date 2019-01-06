function y = skewedNormal(t_range,theta)

% location = theta(1);
a = theta(1);
mu = theta(2);
gamma = theta(3);
tau = theta(4);

%t_star = theta(7);

% gaussian = @(x) (1/sqrt((2*pi))*exp(-x.^2/2));
% skewedgaussian = @(x,alpha) 2*gaussian(x).*normcdf(alpha*x);

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    if t >= tau
        t = (t-mu);
        y(t_ind) = gamma*normpdf(t,0,1)*normcdf(a*t,0,1)/normcdf(0,0,1);
    else
        y(t_ind) = 0;
    end
end
