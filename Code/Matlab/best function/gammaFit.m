function y = gammaFit(t_range,theta)

Alpha = theta(1);
Beta = theta(2);
A = theta(3);
tau = theta(4);
t_star = theta(5);

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    if t >= tau
        y(t_ind) = A*((Beta^Alpha)/gamma(real(Alpha)))*((t-tau)^(Alpha-1))*exp(-Beta*(t-tau)) + t_star;
    else
        y(t_ind) = t_star;
    end
end