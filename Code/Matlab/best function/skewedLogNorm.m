function y = skewedLogNorm(t_range,theta)

mu = theta(1);
sigma = theta(2);
gamma = theta(3);
tau = theta(4);
alpha = theta(5);
beta = theta(6);

for t_ind = 1:size(t_range,2)
    t = t_range(t_ind);
    t = t-tau;
    t = t + beta*2*(mu-t);
    y(t_ind) = gamma.*lognpdf(alpha*t,mu,sigma);
end

    
%     if t >= tau
%         t = t - tau;
%         %t = t + 2*(mu-t);
%         y(t_ind) = gamma.*lognpdf(beta*t,mu,sigma);
%     else
%         y(t_ind) = 0;
%     end
%end