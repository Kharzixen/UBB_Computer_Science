function PoiInterval
n=10000 ; 
alpha=0.001 ; 
x=norminv(1-alpha/2 , 0 , 1); 

lambda=8;
 
X=PoissonAlgorithm(lambda, n);
%hist(X) ; 
S=sum(X) ; 
lambda_min=(2*S + x^2 - x*sqrt(x*S + x^2))/(2*n);
lambda_max=(2*S + x^2 + x*sqrt(x*S + x^2))/(2*n);
fprintf('p_min = %f\np_max = %f\n' , lambda_min , lambda_max) ; 
end