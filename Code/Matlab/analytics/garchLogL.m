function logL = garchLogL(e,p,q)
        
    model = garch('ARCHLags',q);
    disp('finding GARCH model')
    [estModel, paramCovariance, logL] = estimate(model, e');
    k = estModel.Constant; alpha = estModel.ARCH{1}; beta = estModel.GARCH{1};

%     m = length(e);
%     sigma_squared = zeros(m,1);
%     sigma_squared(1) = 1;
%     for i = 2:m
%         sigma_squared(i) = sigmas(sigma_squared(i-1),e(i-1),alpha,beta,k);
%     end
% 
%     logL = -(m/2)*log(2*pi) - 0.5*sum(log(sigma_squared) + (e'.^2)./(sigma_squared));
    
end

function sigma_squared_t = sigmas(sigma_squared_tminus1, e_tminus1, alpha, beta, k)
    sigma_squared_t = k + alpha*(e_tminus1^2) + beta*sigma_squared_tminus1;
end

