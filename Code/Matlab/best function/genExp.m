function y = genExp(params, t_range)

% Unwrap parameters
Alpha = params(1);
Beta = params(2);
A = params(3);
tau = params(4);
% augment time by shift and scale

% calculate fit

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    if t >= tau
        y(t_ind) = A.*((t-tau).^Alpha).* exp(-Beta*((t-tau)));
    else
        y(t_ind) = zeros(size(t,2),1)';
    end
end

end % genExp