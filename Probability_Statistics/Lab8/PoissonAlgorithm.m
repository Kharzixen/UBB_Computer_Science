function X = PoissonAlgorithm(lambda, n)
    if (lambda <= 0)
        print('Wrong Parameter')
        return
    end
    X = zeros(1,n);
    e = exp(1);
    for k=1:n
    u = ULEcuyerRNG();
    i=0;
    p=e^(-lambda);
    s=p;
    while(u>s)
          i=i+1;
          p=(lambda/i) * p;
          s=s+p;
    end
    X(k)=i;
    end
end

