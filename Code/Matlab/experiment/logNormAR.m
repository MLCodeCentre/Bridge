function fit = logNormAR(t_range,theta);

p = theta(end);
theta = theta(1:end-1);

fit(1) = logNorm(t_range(1),theta);

for i = 2:length(t_range)
   fit(i) = logNorm(t_range(i)) -   
end

