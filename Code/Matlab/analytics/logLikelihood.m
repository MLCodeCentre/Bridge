function ll = logLikelihood(data, fit)

% assuming that data-fit is normally distibuted with zero mean.
% MLE variance = std(data-fit)
% mu = 0;
% sigma = sum((data-fit).^2)/length(data);
% 
% l = normpdf(abs(data-fit), 0, sigma);
% ll = sum(log(l));
% it follows the the ll is just
RSS = sum((data-fit).^2);
m = length(data);
ll = -(m/2)*log(RSS);
