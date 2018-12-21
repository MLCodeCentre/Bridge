function fit = NlogNorms(t_range, thetas, N)

    fit = zeros(size(t_range));
    for n = 1:N
        theta = thetas(5*(n-1)+1: 5*(n-1)+5);
        fit = fit + logNorm(t_range,theta);
    end
end