function X = Elso(a,b,n) 
f=@(x) (2/32*(2*x+1/2*(3+x^2) - x^3/3 + 1)) ; 
M=f(2) ; 
X=zeros(1,n) ; 
for i=1:n
    U=ULEcuyerRNG(1) ; 
    V=ULEcuyerRNG(1) ; 
    y=a+(b-a)*V ; 

    while U*M > f(y)
        U=ULEcuyerRNG(1) ; 
        V=ULEcuyerRNG(1) ; 
        y=a+(b-a)*V ; 
    end
    
    X(i)=y ; 
end
end

