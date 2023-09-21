function X = CauchyAltalanos(n , mu , sigma)
e=2.7182 ; 
X=zeros(1,n) ; 
a=sqrt(e)/2 ; 
for i=1:n
    U=ULEcuyerRNG(1) ; 
    V=ULEcuyerRNG(1) ;
    Y=tan(pi*V) ; 
    S=Y^2 ; 
    while U > a*(1+S)*e^(-1*S/2) 
        U=ULEcuyerRNG(1) ; 
        V=ULEcuyerRNG(1) ;
        Y=tan(pi*V) ; 
        S=Y^2 ; 
    end
    X(i)=Y ; 
end
X=X.*sigma+mu ; 
end

