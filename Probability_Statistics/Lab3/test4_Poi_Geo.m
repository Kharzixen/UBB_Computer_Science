n=10000 ; 

X=zeros(1,n) ; 
Y=zeros(1,n) ; 

%Poi : 
lambda=9 ; 
X = PoissonAlgorithm(lambda, n);
subplot(1,2,1) ;
hist(X) ; 


p=2/5;
Y = GeoAlgorithm(p,n);
subplot(1,2,2) ; 
hist(Y) ; 
