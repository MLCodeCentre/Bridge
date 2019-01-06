function y = weibellFit(t_range,theta)

K = theta(1);
Lambda = theta(2);
gamma = theta(3);
tau = theta(4);
t_star = theta(5);

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    t = t-tau;
    y(t_ind) = gamma*wblpdf(t,K,Lambda) + t_star;
end