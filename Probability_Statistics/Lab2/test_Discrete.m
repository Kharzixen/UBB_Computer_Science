%Mellau Mark-Mate , 523/1
%Lab2 ; 

function test_Discrete
    figure(1)
    subplot(1,2,1)
    parameters=2/3 ; 
    x=0:10 ; 
    f=DiscretePDF(x , 'Bernoulli' , parameters) ; 
    F=DiscreteCDF(x , 'Bernoulli' , parameters) ; 
    plot(x , f , 'r*' ) ;
    hold on ; 
    title('Bernoulli')
    stairs(x , F , 'r') ; 
    p = 2/3 ; 
    x = 0:1;
    f = binopdf(0:1,1,p);
    subplot(1,2,2) ; 
    plot(x,f,'b*') ; 
    hold on ;     
    p = 2/3;
    y = binocdf(x,1,p);
    stairs(x,y , 'b') ; 
    
    figure(2)
    subplot(1,2,1) ; 
    nn = 5;
    p = 1/5;
    x = 0:10;
    f=DiscretePDF(x , 'Binomial',[nn,p]) ; 
    F=DiscreteCDF(x , 'Binomial',[nn,p]) ;
    plot(x , f , 'r*') ; 
    hold on ; 
    title('Binomial');
    stairs(x , F , 'r') ; 
    subplot(1,2,2) , plot(x,binopdf(x ,nn,p) , 'b*') ; 
    hold on ; 
    subplot(1,2,2) , stairs(x , binocdf(x , nn,p) , 'b') ;

  
    figure(3)
    subplot(1,2,1) ; 
    x=0:10 ; 
    parameters(1)=7 ; 
    parameters(2)=4 ; 
    parameters(3)=2 ; 
    f=DiscretePDF(x,'Hypergeometric',parameters) ; 
    F=DiscreteCDF(x,'Hypergeometric',parameters) ; 
    plot(x,f , 'r*');
    hold on ; 
    title('Hypergeometric')
    stairs(x , F,'r') ;
    subplot(1,2,2) ;  
    x=0:10 ; 
    subplot(1,2,2) ,plot(x,hygepdf(x,7,4,2),'*b');
    hold on ; 
    subplot(1,2,2),stairs(x,hygecdf(x,7,4,2) , 'b');
    
    figure(4)
    subplot(1,2,1) ; 
    x=0:10 ; 
    f=DiscretePDF(x,'Pascal',[5,1/3]); 
    F=DiscreteCDF(x , 'Pascal' , [5 , 1/3]) ; 
    plot(x , f,'r*');
    hold on ; 
    title('Pascal');
    stairs(x , F , 'r');
    subplot(1,2,2),plot(x,nbinpdf(x , 5 , 1/3),'b*');
    hold on ; 
    subplot(1,2,2),stairs(x,nbincdf(x , 5 , 1/3),'b');
    
    figure(5)
    subplot(1,2,1) ; 
    x=1:10 ; 
    f=DiscretePDF(x , 'Poisson',3) ; 
    F=DiscreteCDF(x , 'Poisson' , 3) ;
    %disp(f) ; 
    %disp(F) ; 
    plot(x , f , 'r*') ; 
    hold on ; 
    title('Poisson')
    stairs(x , F , 'r') ; 
    subplot(1,2,2) , plot(x,poisspdf(x , 3) , 'b*') ; 
    hold on ; 
    subplot(1,2,2) , stairs(x , poisscdf(x , 3) , 'b') ; 
    

end