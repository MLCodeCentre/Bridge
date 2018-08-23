function y = normaliseSignal(x)

y = ((x - mean(x))/(max(x)-abs(min(x))));

