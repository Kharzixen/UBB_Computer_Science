figure(1) ; 
n=10000; 
X=Laplace(n) ; 
subplot(1 , 2 , 1) ; 
histogram(X) ; 

X=Cauchy(n) ; 
subplot(1 , 2 , 2) ; 
histogram(X) ; 


figure(2) ; 
mu=-7 ; 
sigma=2 ; 
X=LaplaceAltalanos(n , mu , sigma) ; 
subplot(1 , 2 , 1) ;
histogram(X) ; 

mu=11 ; 
sigma=1 ; 
X=CauchyAltalanos(n , mu , sigma) ; 
subplot(1 , 2 , 2) ; 
histogram(X) ; 