function X = SecantMethod(distribution_type , parameters ,x_min , x_max , epszilon , n)
    X=zeros(1 , n) ;
    F=@(x)ContinuousCDF(x , distribution_type , parameters) ; 
    u_min=F(x_min) ; 
    u_max=F(x_max) ; 
    i=0;
    for i=1:n
        u=URealRNG(0, 3 , u_min,u_max,1) ; 
        a=x_min ; 
        b=x_max ; 
        x=a+((b-a)*(u-F(a))/(F(b)-F(a))) ; 
        disp(i)
        while((b-a)>epszilon && abs(F(x)-u)>epszilon)
            if(u<F(x))
                b=x;
            else
                a=x ; 
            end
            x=a+((b-a)*(u-F(a))/(F(b)-F(a))) ; 
        end
        X(i)=x ; 
    end
end