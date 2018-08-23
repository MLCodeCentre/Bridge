function y = getSignalEnvolope(x)

[y,~] = envelope(x,20,'peak');
%[y,~] = envelope(x,20,'rms');
[y,~] = envelope(x,30,'analytic');
