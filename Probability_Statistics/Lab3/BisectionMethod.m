function X = BisectionMethod(distribution_type , parameters ,x_min , x_max , epszilon , n)
    X=zeros(1 , n) ;
    F=@(x)ContinuousCDF(x , distribution_type , parameters) ; 
    u_min=F(x_min) ; 
    u_max=F(x_max) ; 
    for i=1:n
        u=URealRNG(0,3,u_min,u_max,1) ; 
        a=x_min ; 
        b=x_max ; 
        x=(a+b)/2 ; 
        disp(i);
        while((b-a)>epszilon && abs(F(x)-u)>epszilon)
            if(u<F(x))
                b=x;
            else
                a=x ; 
            end
            x=(a+b)/2 ; 
        end
        X(i)=x ; 
    end
end

