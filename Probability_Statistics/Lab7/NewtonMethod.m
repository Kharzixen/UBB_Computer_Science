%valami sehr nem jó 


function X = NewtonMethod(distribution_type , parameters , min , max, tau , n)
    F=@(x)ContinuousCDF(x , distribution_type , parameters) ; 
    f=@(x)ContinuousPDF(x , distribution_type , parameters) ; 
    
    if(n<1 || tau <=0)
        error("Wrong Parameters !") ; 
    end
    X=zeros(1,n) ; 
    lepes_max=10000 ;
    for i=1:n
        disp(i) ; 
       u=ULEcuyerRNG(1:1); 
       
       x=ULEcuyerRNG(1)*(max-min)+min ;  
       y=x-(F(x)-u)/f(x) ; 
       while(y<=0)
          x=x/2 ;  
          y=x-(F(x)-u)/f(x) ;
       end   
       db=0;
       while(abs(F(y)-u)>tau && lepes_max>db)
           y=y-(F(y)-u)/f(y) ; 
           db=db+1 ; 
       end
       X(i)=y  ; 
    end
       X=mod(X,max-min)+min ; 
end

