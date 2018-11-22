function y = normaliseSignal(x)

y = 2*((x-min(x))./(max(x) - min(x))) - 1; 
y = y-mean(y);
fprintf('scaled data has mean %f and variance %f \n',mean(y),std(y))
%y = max(0,y - min(y));

