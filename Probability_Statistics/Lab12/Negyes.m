function Negyes
    alpha=0.01 ; 
    k=12 ; 
    N=[24 86 170 227 203 134 83 43 19 6 4 1] ; 
    n=sum(N) ;

    x=0:k-1 ; 
    lambda_=(N*x')/n;
    fprintf("\nMLE lambda = %f\n", lambda_);
    
    p0=DiscretePDF( 0:11 , 'Poisson' , lambda_) ;
    
    p0(12)=1-sum(p0(1:11)) ; 
    chi2value= sum( ((N - n .* p0).^2)./ (n .* p0)) ;
    chi2_quantile = chi2inv(1-alpha, k-2); 

    if(chi2value < chi2_quantile) 
        fprintf("\nA paprikak Poisson eloszlasuak !\n") ; 
        p0
        fprintf("chi2value = %f\n", chi2value);
        fprintf("\nch2_quantile = %f\n", chi2_quantile);
    else
        disp("A paprikak NEM Poisson eloszlasuak !\n") ;
    end

end

