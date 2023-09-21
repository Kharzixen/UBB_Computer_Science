function test2_BisectionSecant(mu,szigma)
     if(szigma <= 0)
        cerror("Wrong parameter(s)! ") ; 
     end
     subplot(1,2,1) ;
     x_min=-12 ; 
     x_max=-4 ; 
     X=BisectionMethod('Normal' , [mu , szigma] , x_min , x_max , 0.01 , 7000) ; 
     hist(X) ;


     subplot(1,2,2) ; 
     x_min=-12; 
     x_max=-4; 
     X=SecantMethod('Normal' , [mu , szigma] , x_min , x_max , 0.01 , 7000) ; 
     hist(X) ;
      
end

