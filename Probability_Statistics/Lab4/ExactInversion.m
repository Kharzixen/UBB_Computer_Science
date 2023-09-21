function X = ExactInversion(distribution_type , parameters , n)
    u=ULEcuyerRNG(n) ; 
    switch distribution_type
        
        %lambda > 0
        case 'Exponential'
            lambda=parameters(1) ; 
            if(lambda <= 0)
                error("Hibás lambda paraméter ! ") ; 
            end
            X=-(1/lambda).*log(u) ;
            
        %alfa > 0
        case 'Cauchy'
            alfa=parameters(1) ; 
            if(alfa <= 0 )
                erros("Hibás alfa paraméter ! " ) ; 
            end
            X=alfa*tan(pi .* u) ;
        %alfa > 0
        case 'Rayleight'
            alfa=parameters(1) ; 
            if(alfa <= 0 )
                erros("Hibás alfa paraméter ! " )
            end
            X=alfa.*sqrt(-2.*log(u)) ; 
        %a >= 0
        case 'Triangular'
            a=parameters(1) ; 
            if(a<0) 
                error("Hibás 'a' paraméter !") ; 
            end
            X=a*(1-sqrt(u)) ;
        %a>0
        case 'RayleightVeg'
            a=parameters(1) ; 
            if(a<=0)
                error("Hibás 'a' paraméter !") ;
            end
            X=sqrt(a*a-2.*log(u)) ; 
        %a , b > 0
        case 'Pareto'
            a=parameters(1) ; 
            b=parameters(2) ; 
            if(a<=0 || b<=0)
                error("Hibás 'a' vagy 'b' paraméter !") ;
            end
            X=b./(u.^(1/a)) ; 
        case 'Sajat'
            X=sqrt(4+45.*u)-4; 
            
    end
end

