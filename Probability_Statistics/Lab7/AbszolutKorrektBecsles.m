function [varhato_ertek , szorasnegyzet ,mu , szigma] = AbszolutKorrektBecsles(distribution_type , parameters , n)
    X=zeros(1,n) ; 
    switch (distribution_type)
        case 'Exponential'
            X=ExactInversion(distribution_type , parameters , n) ; 
            lambda=parameters(1) ; 
            mu=1/lambda ; 
            szigma=1/lambda^2 ; 
        case 'Normal'
            X=LaplaceAltalanos(n , parameters(1) , parameters(2))  ; 
            mu=parameters(1) ; 
            szigma=parameters(2)^2; 
        case 'Uniform'
            X=ULEcuyerRNG(n)*(parameters(2)-parameters(1))+parameters(1) ; 
            mu=1/2*(parameters(1)+parameters(2)) ;
            szigma=1/12*(parameters(2)-parameters(1))^2 ; 
        case 'Binomial'
            m=parameters(2) ;
            p=parameters(1) ;  
            x=0:m ; 
            X=DiscretePDF(x , 'Binomial' , [p , m]) ; 
            t=[x(:) , X(:)]' ;
            X=InversionBySequentialSearch(t , 1 , n) ; 
            mu=p*m ; 
            szigma=m*p*(1-p) ; 
            
        case 'Hypergeometric'
            N=parameters(1) ; 
            M=parameters(2) ; 
            nn=parameters(3) ; 
            x=max(0, nn-N+M):min(n,M) ; 
            xx=DiscretePDF(x , 'Hypergeometric' , [N , M , nn]) ; 
            t=[x(:) , xx(:)]' ; 
            X=InversionBySequentialSearch(t , 1 , n) ; 
            mu=nn*M/N ; 
            szigma=nn*M/N*(N-M)/N*(N-nn)/(N-1) ;
        case 'Geometric'
            p=parameters(1) ; 
            X = GeoAlgorithm(p, n);
            mu=1/p ; 
            szigma=(1-p)/(p^2); 
            
        case 'Triangular'
            a=parameters(1) ; 
            X=ExactInversion('Triangular' , [a] , n) ; 
            mu=a/3 ; 
            szigma=a^2/18 ; 
            
        case 'Gamma'
            a=parameters(1) ; 
            b=parameters(2) ; 
            X=BisectionMethod('Gamma' , [a,b] ,0 , 20 , 0.001 , n) ; 
            mu=a*b ; 
            szigma=a*b^2; 
    end
    varhato_ertek=mean(X) ; 
    szorasnegyzet=var(X) ; 
end

