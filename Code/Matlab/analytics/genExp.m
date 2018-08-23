function x = genExp(params, t)

% Unwrap parameters
A = params(1);
B = params(2);
tau = params(3);

% augment time by shift and scale
t = (t - tau);
t = max(0, t);
t = min(t, 60);

% calculate fit
x = A*((t + 1E-08) .* exp(-1/B*(t + 1E-08)));

end % genExp