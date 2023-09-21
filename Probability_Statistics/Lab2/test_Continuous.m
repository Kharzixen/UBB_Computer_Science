function test_Continuous

    figure(1)
    hold on;
    subplot(1,2,1) ; 
    x=[-6:0.01:6] ; 
    plot(x , ContinuousPDF(x , 'Uniform' , [-2,4]) , 'g') ; 
    hold on ; 
    title('Uniform')
    plot(x , ContinuousCDF(x , 'Uniform' , [-2,4] ) , 'r') ; 
    subplot(1,2,2) ; 
    plot(x , unifpdf(x , -2 ,4) , 'c') ; 
    hold on ; 
    title('Built-in Uniform')
    plot(x , unifcdf(x , -2 , 4) , 'b') ;  
    
    figure(2) ; 
    subplot(1,2,1) ; 
    x=[-6:0.01:6];
    subplot(1,2,1);
    plot(x,ContinuousPDF(x,'Exponential',3/2) , 'g') ; 
    hold on ; 
    title('Exponential')
    plot(x , ContinuousCDF(x,'Exponential',3/2) , 'r'); 
    subplot(1,2,2);
    plot(x,exppdf(x,2/3) , 'c');
    hold on ; 
    title('Built-in Exponential')
    plot(x , expcdf(x,2/3) , 'b');
  
    figure(3)
    n=2;
    sigma=1; 
    subplot(1,2,1);
    x=[-6:0.01:6];
    plot(x , ContinuousPDF(x , 'Pearson' , [n,sigma]) , 'g') ; 
    hold on ; 
    title('Pearson')
    plot(x , ContinuousCDF(x , 'Pearson' , [n,sigma] ) , 'r') ; 
    subplot(1,2,2);
    plot(x, gampdf(x,n/2, 2*sigma^2), 'g');
    hold on;
    title('Peason with inbuilt gamma')
    plot(x, gamcdf(x,n/2, 2*sigma^2), 'r');
    
    figure(4)
    subplot(1,2,1)
    x=[-6:0.01:6];
    plot(x , ContinuousPDF(x,'Gamma',[1/2,2]) , 'g');
    hold on ; 
    title('Gamma')
    plot(x , ContinuousCDF(x,'Gamma',[1/2,2]) , 'r');
    subplot(1,2,2) ; 
    plot(x , gampdf(x,1/2,2) , 'g');
    hold on ; 
    title('Built-in gamma')
    plot(x , gamcdf(x,1/2,2) , 'r');
    
    figure(5) ; 
    subplot(1,2,1) ; 
    x=[-6:0.01:6];
    plot(x , ContinuousPDF(x,'Student',6), 'g');
    hold on ; 
    title('Student')
    plot(x , ContinuousCDF(x,'Student',6) , 'r') ; 
    subplot(1,2,2) ; 
    plot(x , tpdf(x,6) , 'g');
    hold on ;
    title('Built-in Student')
    plot(x , tcdf(x,6) , 'r');
    
end