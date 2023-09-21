figure(1) ; 

subplot(1,4,1) ;
X=ExactInversion('Exponential' , 5 , 10000) ; 
hist(X) ; 

subplot(1,4,2) ; 
X=ExactInversion('Cauchy' , 5 , 10000) ; 
hist(X) ; 

subplot(1,4,3) ; 
X=ExactInversion('Rayleight' , 5 , 10000) ; 
hist(X) ; 

subplot(1,4,4) ; 
X=ExactInversion('Triangular' , 5 , 10000) ; 
hist(X) ; 

figure(2) ; 
subplot(1,3,1) ; 
X=ExactInversion('RayleightVeg' , 5 , 10000) ; 
hist(X) ; 

subplot(1,3,2) ; 
X=ExactInversion('Pareto' ,[5,2] , 10000) ; 
hist(X) ; 

subplot(1,3,3) ; 
X=ExactInversion('Sajat' , [] , 10000) ; 
hist(X) ; 

%sajat.


