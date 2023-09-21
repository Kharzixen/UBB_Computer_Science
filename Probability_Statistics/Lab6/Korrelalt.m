function [Y , S] = Korrelalt(ro , mu1 , sigma1 , mu2 , sigma2 , n)
mu=[mu1;mu2] ; 
S=[sigma1^2 , ro*sigma1*sigma2 ; ro*sigma1*sigma2 , sigma2^2] ; 
L=[sigma1 , 0 ; ro*sigma2 , sigma2*sqrt(1-ro^2)] ; 
T=2*pi ; 
Y=zeros(n,2) ; 
for i=1:n
   U1=ULEcuyerRNG() ; 
   U2=ULEcuyerRNG() ; 
   R=sqrt(-2*log(U1)) ; 
   Tetha=T*U2 ; 
   X=[R*cos(Tetha) ; R*sin(Tetha)] ; 
   foo=mu+L*X ; 
   Y(i,1)=foo(1,1) ; 
   Y(i,2)=foo(2,1) ; 
end
end

