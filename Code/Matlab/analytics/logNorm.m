function fit = logNorm(params, t)

A = params(1);
sigma = params(2);
mu = params(3);
tau = params(4);
t_star = 0.03;

t = t-tau;
t = max(0, t);
t = min(t, 60);
fit = A.*lognpdf(t+1E-08, mu, sigma) + t_star;