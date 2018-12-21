function y = pointDiffusion(t_range,theta)

M = theta(1);
D = theta(2);
x = theta(3);
tau = theta(4);
t_star = theta(5);

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    if t >= tau
        y(t_ind) = M/sqrt(4*pi*D*(t-tau))*exp(-x*2/(4*D*(t-tau))) + t_star;
    else
        y(t_ind) = t_star;
    end
end
