function X = Laplace(n)
X=zeros(1,n) ; 
for i=1:n   
    V=2*ULEcuyerRNG(1)-1 ;
    U=ULEcuyerRNG() ; 
    Y=-log(U) ; 
    while (Y-1)^2> -2*log(abs(V)) 
        V=2*ULEcuyerRNG(1)-1 ;      %V ~ U([-1 , 1])
        %Exp(1) eloszlású szám
        U=ULEcuyerRNG(1) ; 
        Y=ExactInversion('Exponential', [1], 1); 
    end
    X(i)=Y*sign(V) ; 
end
end

