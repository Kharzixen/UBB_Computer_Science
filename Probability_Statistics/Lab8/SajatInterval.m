function SajatInterval
n=10000 ; 
alpha=0.001 ; 
x=norminv(1-alpha/2 , 0 , 1); 

teta = 3;

X = SajatMintavetel(teta, n);

%hist(X) ; 
S=sum(X) ; 
teta_min= (n*(-x/sqrt(n) + sqrt(2))) / (6*sqrt(2)*S);
teta_max= (n*(+x/sqrt(n) + sqrt(2))) / (6*sqrt(2)*S);
fprintf('teta_min = %f\nteta_max = %f\n' , teta_min , teta_max) ; 
end