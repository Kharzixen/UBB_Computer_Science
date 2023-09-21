function GeoInterval
n=10000 ; 
alpha=0.01 ; 
x=norminv(1-alpha/2 , 0 , 1) ; 
p=0.53;
 
X=GeoAlgorithm(p, n);
%hist(X) ; 
S=sum(X) ; 
p_min=(n*((-x)^2 + 2*S - x*sqrt(x^2 - 4*(S-(S^2)/n)))/(2*S^2));
p_max=(n*((-x)^2 + 2*S + x*sqrt(x^2 - 4*(S-(S^2)/n)))/(2*S^2));
fprintf('p_min = %f\np_max = %f\n' , p_min , p_max) ; 
end

