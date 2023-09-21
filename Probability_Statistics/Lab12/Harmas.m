function Harmas
    alpha = 0.02 ; 
    k = 6 ; 
    N = [284 259 241 210 238 268] ; 
    n=sum(N) ; 
    
    hist(N, k);
    
    p0=ones(1 , k) .* (1/6) ; 
    
    chi2value = sum( ((N - n .* p0).^2)./ (n .* p0)) 
    chi2_quantile = chi2inv(1-alpha , k-1) 
    
    if(chi2value < chi2_quantile) 
        fprintf("\n Szabalyos hatoldalú kocka alaku !\n") ; 
    else
        fprintf("\n Nem szabalyos hatoldalú kocka alapú !\n") ;
    end
end

