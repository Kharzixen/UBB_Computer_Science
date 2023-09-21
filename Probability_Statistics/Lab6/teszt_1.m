n=10000 ; 

figure(1) ; 
X=Marsaglia(n) ; 
subplot(1,2,1) ; 
plot(X(1 , :) , X(2, :) , '*r') ; 
subplot(1,2,2) ;
hist3(X') ; 

figure(2) ; 
ro=-0.87 ; 
mu1=30 ; 
sigma1=2 ; 
mu2=5 ; 
sigma2=3 ; 
X=Korrelalt(ro , mu1 , sigma1 , mu2 , sigma2 , n) ; 
subplot(1,2,1) ; 
plot(X(: , 1) , X(: , 2) , '*g') ; 
subplot(1,2,2) ; 
hist3(X) ; 