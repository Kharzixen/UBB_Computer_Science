function n = OptimalCPUsize
mu=2800 ; 
sigma=708 ; 
epsilon=0.08*mu ; 
prob_to_reach=1-0.1; %1-alfa -> alfa=0.1 . 
hold on ; 
n=0 ; 
p=0 ; 
exp_count=3000 ; 
while(p<prob_to_reach)
    n=n+1 ; 
    plot([0,n] , [prob_to_reach , prob_to_reach] , 'r') ; 
    good=0 ; 
    for i=1:exp_count
        X=LaplaceAltalanos(n , mu , sigma) ; 
        if(abs(mean(X)-mu)<epsilon)
            good=good+1 ; 
        end
    end
    p=good/exp_count ; 
    stem(n,p) ; 
    drawnow ; 
end

