[mu_felv , szigma_felv , mu , szigma]=AbszolutKorrektBecsles('Exponential', 1/12 , 10000) ; 
fprintf('\nExponencialis eloszlas : \n') ; 
fprintf('Elmeleti varhato ertek : %f , Sajat varhato ertek : %f' , mu , mu_felv) ; 
fprintf('\nElmeleti szorasnegyzet: %f , sajat szorasnegyzet : %f\n' , szigma , szigma_felv) ; 

[mu_felv , szigma_felv , mu , szigma]=AbszolutKorrektBecsles('Normal', [6 , 3]  , 10000) ; 
fprintf('\nNormal eloszlas : \n') ; 
fprintf('Elmeleti varhato ertek : %f , Sajat varhato ertek : %f' , mu , mu_felv) ; 
fprintf('\nElmeleti szorasnegyzet: %f , sajat szorasnegyzet : %f\n' , szigma , szigma_felv) ; 

[mu_felv , szigma_felv , mu , szigma]=AbszolutKorrektBecsles('Uniform', [5 , 7]  , 10000) ; 
fprintf('\nUniform eloszlas : \n') ; 
fprintf('Elmeleti varhato ertek : %f , Sajat varhato ertek : %f' , mu , mu_felv) ; 
fprintf('\nElmeleti szorasnegyzet: %f , sajat szorasnegyzet : %f\n' , szigma , szigma_felv) ; 

[mu_felv , szigma_felv , mu , szigma]=AbszolutKorrektBecsles('Binomial', [1/2, 14]  , 10000) ; 
fprintf('\nBinomial eloszlas : \n') ; 
fprintf('Elmeleti varhato ertek : %f , Sajat varhato ertek : %f' , mu , mu_felv) ; 
fprintf('\nElmeleti szorasnegyzet: %f , sajat szorasnegyzet : %f\n' , szigma , szigma_felv) ; 

[mu_felv , szigma_felv , mu , szigma]=AbszolutKorrektBecsles('Hypergeometric', [16 , 7 , 8]  , 10000) ; 
fprintf('\nHypergeometric eloszlas : \n') ; 
fprintf('Elmeleti varhato ertek : %f , Sajat varhato ertek : %f' , mu , mu_felv) ; 
fprintf('\nElmeleti szorasnegyzet: %f , sajat szorasnegyzet : %f\n' , szigma , szigma_felv) ; 

[mu_felv , szigma_felv , mu , szigma]=AbszolutKorrektBecsles('Geometric', 1/6 , 10000) ; 
fprintf('\nGeometric eloszlas : \n') ; 
fprintf('Elmeleti varhato ertek : %f , Sajat varhato ertek : %f' , mu , mu_felv) ; 
fprintf('\nElmeleti szorasnegyzet: %f , sajat szorasnegyzet : %f\n' , szigma , szigma_felv) ; 

[mu_felv , szigma_felv , mu , szigma]=AbszolutKorrektBecsles('Triangular', 21  , 10000) ; 
fprintf('\nTriangular eloszlas : \n') ; 
fprintf('Elmeleti varhato ertek : %f , Sajat varhato ertek : %f' , mu , mu_felv) ; 
fprintf('\nElmeleti szorasnegyzet: %f , sajat szorasnegyzet : %f\n' , szigma , szigma_felv) ; 

fprintf('\nNE NYOMD EL , FUT A GAMMA\n') ; 
[mu_felv , szigma_felv , mu , szigma]=AbszolutKorrektBecsles('Gamma', [7 , 1] , 10000) ; 
fprintf('\nGamma eloszlas : \n') ; 
fprintf('Elmeleti varhato ertek : %f , Sajat varhato ertek : %f' , mu , mu_felv) ; 
fprintf('\nElmeleti szorasnegyzet: %f , sajat szorasnegyzet : %f\n' , szigma , szigma_felv) ; 


    