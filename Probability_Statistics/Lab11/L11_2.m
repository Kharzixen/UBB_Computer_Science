clc ; 

X = [750, 753, 747, 748, 751, 748, 751, 753, 752, 749, 750,753, 748, 752, 748, 752, 749, 751, 750, 749];
Y = [746, 753, 747, 751, 751, 747, 748, 745, 754, 747, 744,748, 750, 747, 748, 746, 754, 752, 745];
alpha=0.05 ; 
equal_std = 0;
[ci_f, ci_lambda, f_value, p_value, H] = FTest2D(X, Y, alpha, 'both') ; 

fprintf("\na)-------------------\n\n") ; 

if(H==0)
    fprintf("A ket meres hibaja ugyanakkora ! H == %d .\n" , H) ;
    equal_std = 1;
else
    fprintf("A ket meres hibaja NEM ugyanakkora ! H == %d .\n" , H) ; 
    equal_std = 0;
end
fprintf("\nMegbizhatosagi intervallum u ci_f = (%f , %f) .\n" , ci_f(1) , ci_f(2)) ; 
fprintf("Megbizhatosagi intervallum delta ci_lambda = (%f , %f) .\n" , ci_lambda(1) , ci_lambda(2)) ; 
fprintf("f_value = %f\n" , f_value) ;
fprintf("p_value = %f\n\n" , p_value) ; 

fprintf("\nb)-------------------\n\n") ; 

alpha=0.09;
%mu1>mu2 -> right
[ci_t, ci_delta, t_value, p_value, H] = TTest2D(X, Y, equal_std, alpha, 'right') ; 

if(H==0)
    fprintf("HAMIS: Az elso cukraszda eseten az atlagos tomeg nem nagyobb ! H == %d .\n" , H) ; 
else
    fprintf("IGAZ: Az elso cukraszda eseten az atlagos tomeg nagyobb ! H == %d " , H) ; 
end
fprintf("\nMegbizhatosagi intervallum u ci_t = (%f , %f) .\n" , ci_t(1) , ci_t(2)) ; 
fprintf("Megbizhatosagi intervallum delta ci_delta = (%f , %f) .\n" , ci_delta(1) , ci_delta(2)) ; 
fprintf("t_value = %f\n" , t_value) ;
fprintf("p_value = %f\n\n\n" , p_value) ; 