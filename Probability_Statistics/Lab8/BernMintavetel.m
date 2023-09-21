function X = BernMintavetel(p , n)
        x=0:1 ; 
        xx=DiscretePDF(x , 'Bernoulli' , p) ; 
        t=[x(:) , xx(:)]' ; 
        X=InversionBySequentialSearch(t , 1 , n) ; 
end

