function [e_hat, logL, e_hat_res, pcaf] = ARlogL(e,q,data,thresh)
    
    [pcaf, lags] = parcorr(e,q);
    e_thresh = e(data>thresh);
    e_hat = e_thresh(q+1:end);
    for i = 1:q
        e_hat = e_hat - pcaf(i+1).*e_thresh((q+1)-i:end-i); 
    end
    
    %figure
    %histfit(e_hat);
    disp('---------------')
    fprintf('e_hat mean: %.4f\n',mean(e_hat));
    fprintf('e_hat var: %.4f\n',std(e_hat));
    
    fprintf('e SSE: %.8f\n',sum(e.^2));
    fprintf('e_hat SSE: %.8f\n',sum(e_hat.^2));
    m = length(e_hat);
    e_hat_res = sum(e_hat.^2);
    logL = -0.5*m*log(e_hat_res);
    fprintf('logL: %.8f\n',logL);
    disp('---------------')
end
