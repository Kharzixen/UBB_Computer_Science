X = [18.0, 13.9, 21.3, 19.4, 19.6, 20.8, 17.2, 18.5, 20.3, 21.2,17.4, 16.6, 18.9, 20.4, 21.3, 20.2];
Y = [21.7, 20.8, 18.7, 19.9, 18.6, 19.9, 19.5, 21.8, 19.7, 18.8,19.9, 22.7];

sigma1 = 2.0;
sigma2 = 1.3;

%a)---------------------------------
alpha = 1 - 0.93;
mu0 = 20;
[ci_u, ci_mu, u_value, p_value , H] = UTest(X, mu0, sigma1, alpha, 'left');
if H==0
    fprintf('A) HAMIS! Az elso szelturbina hatasfoka NEM kisebb mint mu0=20 KW. | H == %d\n', H);
else 
    fprintf('A) IGAZ! Az elso szelturbina hatasfoka KISEBB mint mu0=20 KW. | H == %d\n', H);
end
fprintf("\nMegbizhatosagi intervallum u ci_u = (%f , %f) .\n" , ci_u(1) , ci_u(2)) ; 
fprintf("Megbizhatosagi intervallum delta ci_delta = (%f , %f) .\n" , ci_mu(1) , ci_mu(2)) ; 
fprintf("u_value = %f\n" , u_value) ;
fprintf("p_value = %f\n\n" , p_value) ; 

%a)---------------------------------

alpha = 1 - 0.92;
[ci_u, ci_delta, u_value, p_value, H] = UTest2D(X ,Y , sigma1 , sigma2 , alpha , 'left') ; 
%a masodik szelturbina hatasfokat nagyobb mint az elso turbina hatasfoka
if H==0
    fprintf('B) HAMIS! Az elso szelturbina hatasfoka NAGYOBB mint a masodik turbina hatasfoka. | H == %d\n', H);
else 
    fprintf('B) IGAZ! Az elso szelturbina hatasfoka KISEBB mint a masodik turbina hatasfoka. | H == %d\n', H);
end
fprintf("\nMegbizhatosagi intervallum u ci_u = (%f , %f) .\n" , ci_u(1) , ci_u(2)) ; 
fprintf("Megbizhatosagi intervallum delta ci_delta = (%f , %f) .\n" , ci_delta(1) , ci_delta(2)) ; 
fprintf("u_value = %f\n" , u_value) ;
fprintf("p_value = %f\n\n" , p_value) ; 
