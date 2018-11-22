function y = weibellFit(params,t_range)

K = params(1);
Lambda = params(2);
A = params(3);
tau = params(4);

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    if t >= tau
        y(t_ind) = A.*(K/Lambda).*(((t-tau)/Lambda).^(K-1)).*exp(-((t-tau)/Lambda).^(K));
    else
        y(t_ind) = zeros(size(t,2),1)';
    end
end