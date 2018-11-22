function y = gammaFit(params,t_range)

Alpha = params(1);
Beta = params(2);
A = params(3);
tau = params(4);

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    if t >= tau
        y(t_ind) = A.*((Beta.^Alpha)./gamma(real(Alpha))).*((t-tau).^(Alpha-1)).*exp(-Beta.*(t-tau));
    else
        y(t_ind) = zeros(size(t,2),1)';
    end
end