function y = getSignalEnvolope(x)

%[y,~] = envelope(x,20,'peak');
[y,~] = envelope(x,10,'rms');
%[y,~] = envelope(x);
