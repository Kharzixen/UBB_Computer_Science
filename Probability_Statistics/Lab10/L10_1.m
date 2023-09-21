clc ; 
X = [30, 31, 30, 32, 30, 30, 31, 29, 31, 30, 31, 30, 30, 30, 29, 31, 31, 30, 31, 30];
alfa=0.07 ; 
mu0=30 ; 

[ci_t, ci_mu, t_value, p_value, H] = TTest(X , mu0 , alfa , 'right');

if(H==0) 
    fprintf("HAMIS : Nem tolt atlagosan tobbet fel percnel.\nH == %d \n" , H) ;
else
     fprintf("IGAZ: Atlagosan tobbet tolt fel percnel.\nH == %d  \n" , H) ; 
end
fprintf("\nMegbizhatosagi intervallum u ci_t = (%f , %f) .\n" , ci_t(1) , ci_t(2)) ; 
fprintf("Megbizhatosagi intervallum delta ci_mu = (%f , %f) .\n" , ci_mu(1) , ci_mu(2)) ; 
fprintf("u_value = %f\n" , t_value) ;
fprintf("p_value = %f\n\n" , p_value) ; 