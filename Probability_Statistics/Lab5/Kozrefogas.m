function X = Kozrefogas(n)
X=zeros(1,n) ; 
e=exp(1) ; 
alfa=1/sqrt(e) ; 
beta=1/2 ; 
gamma=sqrt(2) ; 
lepesek=0 ; 
kiertekelesek=0 ; 
for i=1:n
   lepesek=lepesek+1 ; 
   U=ULEcuyerRNG(1) ; 
   V=ULEcuyerRNG(1) ; 
   Y=tan(pi*V) ; 
   S=beta*Y^2 ; 
   W=alfa*U/(beta+S) ; 
   if abs(Y)>gamma 
       L=0 ;
   else
       L=(W<=(1-S)) ; 
   end
   if(L==0)
       kiertekelesek=kiertekelesek+1 ; 
       L=(W<=e^(-S)) ; 
   end
   
   while L~=1
       lepesek=lepesek+1 ; 
       U=ULEcuyerRNG(1) ; 
       V=ULEcuyerRNG(1) ; 
       Y=tan(pi*V) ; 
       S=beta*Y^2 ; 
       W=alfa*U/(beta+S) ; 
       if abs(Y)>gamma 
           L=0 ;
       else
           L=(W<=(1-S)) ; 
       end
       if(L==0)
           kiertekelesek=kiertekelesek+1 ; 
           L=(W<=e^(-S)) ; 
       end
   end
   X(i)=Y ; 
end
disp("Lepesek=") ; 
disp(lepesek/10000) ;
disp("Kiertekeles=") ; 
disp(kiertekelesek/10000) ; 
end

