function y = logNorm(t_range,theta)

mu = theta(1);
sigma = theta(2);
gamma = theta(3);
tau = theta(4);
t_star = theta(5);

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    if t >= tau
        y(t_ind) = gamma.*lognpdf(t-tau,mu,sigma) + t_star;
    else
        y(t_ind) = t_star;
    end
end

