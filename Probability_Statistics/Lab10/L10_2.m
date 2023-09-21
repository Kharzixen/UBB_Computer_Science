clc ; 

%---9-es labor /1---

X = [18.0, 13.9, 21.3, 19.4, 19.6, 20.8, 17.2, 18.5, 20.3, 21.2,17.4, 16.6, 18.9, 20.4, 21.3, 20.2];
Y = [21.7, 20.8, 18.7, 19.9, 18.6, 19.9, 19.5, 21.8, 19.7, 18.8,19.9, 22.7];

% a) --------------
fprintf("\n1/a)-----------------------\n");
alfa=0.07 ;
mu_0=20 ; 
[ci_u1 , ci_mu1 , u_value1 , p_value1 , H1]=TTest(X , mu_0 , alfa, 'left') ; 
if(H1==0) 
    fprintf('A) HAMIS! Az elso szelturbina hatasfoka NEM kisebb mint mu0=20 KW. | H == %d\n', H);
else 
    fprintf('A) IGAZ! Az elso szelturbina hatasfoka KISEBB mint mu0=20 KW. | H == %d\n', H);
end

fprintf("\nMegbizhatosagi intervallum u ci_u = (%f , %f) .\n" , ci_u1(1) , ci_u1(2)) ; 
fprintf("Megbizhatosagi intervallum mu ci_mu = (%f , %f) .\n" , ci_mu1(1) , ci_mu1(2)) ; 
fprintf("u_value = %f\n" , u_value1) ;
fprintf("p_value = %f\n" , p_value1) ; 

% b)------------
fprintf("\n1/b)-----------------------\n") ; 
alfa=0.08 ;  
[ci_u2 , ci_mu2 , u_value2 , p_value2 , H2]=TTest2D(X, Y, 0, alfa , 'left') ; 
if(H2==0) 
   fprintf('B) HAMIS! Az elso szelturbina hatasfoka NAGYOBB mint a masodik turbina hatasfoka. | H == %d\n', H);
else 
    fprintf('B) IGAZ! Az elso szelturbina hatasfoka KISEBB mint a masodik turbina hatasfoka. | H == %d\n', H);
end

fprintf("\nMegbizhatosagi intervallum u ci_u = (%f , %f) .\n" , ci_u2(1) , ci_u2(2)) ; 
fprintf("Megbizhatosagi intervallum mu ci_mu = (%f , %f) .\n" , ci_mu2(1) , ci_mu2(2)) ; 
fprintf("u_value = %f\n" , u_value2) ;
fprintf("p_value = %f\n" , p_value2) ; 

fprintf("\n2)-----------------------\n") ; 

X = [500.80, 499.96, 497.03, 503.36, 498.34, 507.65, 498.44, 501.64,497.43, 500.50, 499.33, 501.67, 505.21, 497.63];
Y = [500.11, 498.49, 500.31, 501.59, 498.36, 496.89, 497.43, 499.19,498.42, 497.40, 500.12, 501.80, 499.25, 499.39, 493.40, 497.68,495.82, 498.84];
alfa=0.04 ; 

%u1<u2 -> u1-u2<0 -> baloldal ; 
[ci_u , ci_delta , u_value , p_value , H]=TTest2D(X ,Y , 0 ,  alfa , 'right') ; 
if H==0
    fprintf('B) HAMIS! A masodik gep nem adagol kevesebbet mint az elso. | H == %d\n', H);
else 
    fprintf('B) IGAZ! A masodik gep kevesebbet adagol mint az elso. | H == %d\n', H);
end

fprintf("\nMegbizhatosagi intervallum u ci_u = (%f , %f) .\n" , ci_u(1) , ci_u(2)) ; 
fprintf("Megbizhatosagi intervallum delta ci_delta = (%f , %f) .\n" , ci_delta(1) , ci_delta(2)) ; 
fprintf("u_value = %f\n" , u_value) ;
fprintf("p_value = %f\n\n" , p_value) ; 

