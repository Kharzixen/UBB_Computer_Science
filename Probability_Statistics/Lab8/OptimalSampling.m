function n = OptimalSampling
epsilon=0.05 ; 
prob_to_reach=0.95 ; 
mu=1/2 ; 

exp_count=3000 ; 
n=0 ; 
p=0 ; 
hold on 
while (p<prob_to_reach)
   n=n+1 ; 
   good=0 ; 
   plot([0,n] , [prob_to_reach , prob_to_reach] , 'r') ; 
   for i=1:exp_count
       X=BernMintavetel(1/2 ,n) ;
       if(abs(mean(X)-mu)<epsilon)
           good=good+1 ; 
       end
   end
   p=good/exp_count ; 
   stem(n,p) ; 
   drawnow ; 
end
end

