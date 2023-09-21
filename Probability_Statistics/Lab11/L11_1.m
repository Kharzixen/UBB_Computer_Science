clc ; 

X = [100.8, 102.5, 98.2, 97.5, 99.1, 99.4, 100.9, 95.6, 99.3, 99.1, 98.3,99.6, 96.2, 99.0, 100.8, 97.5, 99.3, 97.2, 98.7, 98.2, 99.0, 98.6,98.8, 97.3, 100.6, 99.3, 96.5];
alpha=0.04 ; 
sigma_0=1.2 ; 
[ci_chi2, ci_std, chi2_value, p_value, H] = Chi2Test(X, sigma_0, alpha, 'right') ; 

if(H==0)
    fprintf("HAMIS: Nem haladja meg az 1.2 ml-t a hiba ! H == %d \n" , H) ; 
else
    fprintf("Igaz: Meghaladja az 1.2 ml-t a hiba ! H == %d \n" , H) ; 
end
fprintf("\nMegbizhatosagi intervallum u ci_chi2 = (%f , %f) .\n" , ci_chi2(1) , ci_chi2(2)) ; 
fprintf("Megbizhatosagi intervallum delta ci_std = (%f , %f) .\n" , ci_std(1) , ci_std(2)) ; 
fprintf("chi2_value = %f\n" , chi2_value) ;
fprintf("p_value = %f\n\n" , p_value) ; 