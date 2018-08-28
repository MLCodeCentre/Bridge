function y = normaliseSignal(x)

y = (x - mean(x))/(max(x)-min(x));
fprintf('scaled data has mean %f and variance %f \n',mean(y),std(y))

