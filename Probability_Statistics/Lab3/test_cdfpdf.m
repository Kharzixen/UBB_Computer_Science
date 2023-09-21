    figure(1)
    x=[-6:0.01:6];
    plot(x , ContinuousPDF(x,'Sajat',[]) , 'g');
    hold on ; 
    title('Sajat')
    plot(x , ContinuousCDF(x,'Sajat',[]) , 'r');