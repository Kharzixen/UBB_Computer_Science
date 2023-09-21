% a=1 ; 
% b=6 ; 
% X=NewtonMethod('Gamma' , [a,b] , 1/100 , 35 ,0.01 , 7000); 
% subplot(1,2,1) ; 
% hist(X) ; 

a=11/3 ; 
b=4 ; 
X=NewtonMethod('Gamma' , [a,b] ,  1/100 , 35 , 0.01 , 7000) ; 
subplot(1,2,2) ; 
hist(X) ; 