X = [500.80, 499.96, 497.03, 503.36, 498.34, 507.65, 498.44, 501.64,497.43, 500.50, 499.33, 501.67, 505.21, 497.63];
Y = [500.11, 498.49, 500.31, 501.59, 498.36, 496.89, 497.43, 499.19,498.42, 497.40, 500.12, 501.80, 499.25, 499.39, 493.40, 497.68,495.82, 498.84];

sigma1 = 3.1;
sigma2 = 2.1;
alpha = 1-0.96;

[ci_u, ci_delta, u_value, p_value, H] = UTest2D(X ,Y , sigma1 , sigma2 , alpha , 'right') ; 
%a masodik gep kevesebbet adagol mint az elso -> az elso tobbet adagol
%mint a masodik -> right
if H==0
    fprintf('B) HAMIS! A masodik gep nem adagol kevesebbet mint az elso. | H == %d\n', H);
else 
    fprintf('B) IGAZ! A masodik gep kevesebbet adagol mint az elso. | H == %d\n', H);
end

fprintf("\nMegbizhatosagi intervallum u ci_u = (%f , %f) .\n" , ci_u(1) , ci_u(2)) ; 
fprintf("Megbizhatosagi intervallum delta ci_delta = (%f , %f) .\n" , ci_delta(1) , ci_delta(2)) ; 
fprintf("u_value = %f\n" , u_value) ;
fprintf("p_value = %f\n\n" , p_value) ; 