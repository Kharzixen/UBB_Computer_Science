function Y = GeoAlgorithm(p,n)
    if(p<=0 || p>=1)
       print('Wrong Parameter');
       return;
    end
    Y = zeros(1,n);
    lamda = -log(1-p);
    Y=ExactInversion("Exponential",lamda,n);
    Y=ceil(Y) ; 
end

