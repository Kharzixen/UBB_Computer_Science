function X = Marsaglia(n)
X=zeros(2 , n) ; 

for i=1:n
    disp(i);
    U1=ULEcuyerRNG() ; 
    U2=ULEcuyerRNG() ; 
    Z1=2*U1-1 ; 
    Z2=2*U2-1 ; 
    S=Z1^2+Z2^2 ; 
    while (~(0<S && S<=1))
        U1=ULEcuyerRNG() ; 
        U2=ULEcuyerRNG() ; 
        Z1=2*U1-1 ; 
        Z2=2*U2-1 ; 
        S=Z1^2+Z2^2 ; 
    end
    T=sqrt(-2*log(S)/S) ; 
    X(1,i)=T*Z1 ; 
    X(2,i)=T*Z2 ; 
end
end

