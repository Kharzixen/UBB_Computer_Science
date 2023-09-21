function X = ElutasitasModszere(a1 , b1  , a2, b2 , n)
f=@(x,y) 15/38*(x*y^2 + (1+(y^4)/2) + (x/2)*((1/4)+x)) ; 
X=zeros(n , 2) ; 
M=f(1 , 1) ; 

for i=1:n
    U=ULEcuyerRNG() ; 
    V1=ULEcuyerRNG() ; 
    V2=ULEcuyerRNG() ; 
    Y1=a1+(b1-a1)*V1 ; 
    Y2=a2+(b2-a2)*V2 ; 
    while(U*M>f(Y1 , Y2))
        U=ULEcuyerRNG() ; 
        V1=ULEcuyerRNG() ; 
        V2=ULEcuyerRNG() ; 
        Y1=a1+(b1-a1)*V1 ; 
        Y2=a2+(b2-a2)*V2 ; 
    end
    X(i,1)=Y1 ; 
    X(i,2)=Y2 ; 
end
 fprintf('\nX: becsles a varhato ertekre : %f\n' , mean(X(: , 1))) ; 
 fprintf('X: becsles a szorasnegyzetre : %f\n' , var(X(:,1))) ; 
 
 fprintf('\nY: becsles a varhato ertekre : %f\n' , mean(X(: , 2))) ; 
 fprintf('Y: becsles a szorasnegyzetre : %f\n' , var(X(:,2))) ; 
end

