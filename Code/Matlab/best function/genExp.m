function y = genExp(t_range, theta)

% Unwrap parameters
Alpha = theta(1);
Beta = theta(2);
A = theta(3);
tau = theta(4);
t_star = theta(5);
% augment time by shift and scale

% calculate fit

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    if t >= tau
        y(t_ind) = A*((t-tau)^Alpha)* exp(-Beta*((t-tau))) + t_star;
    else
        y(t_ind) = t_star;
    end
end

end % genExp