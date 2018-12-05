function garchErrors

close all
% simulating errors - normally distributed...
m = 8000;
E_range = 0.1:0.01:0.3;

logLs = [];
for E = E_range
    E
    e = E.*rand(m,1);
    model = garch('ARCHLags',1);
    disp('finding GARCH model')
    [estModel, paramCovariance, logL] = estimate(model, e);
    logLs = [logLs, logL]
end
plot(E_range,logLs)
