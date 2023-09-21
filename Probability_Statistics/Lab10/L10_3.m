clc ; 

X = [253.3, 247.7, 251.9, 249.4, 252.4, 247.2, 250.8, 251.9, 250.1, 249.0,245.6, 248.2, 249.6, 251.5, 248.1];
Y = [249.9, 249.6, 248.1, 253.9, 250.5, 251.1, 250.6, 250.7, 248.1, 248.7,248.0, 254.5, 249.6, 246.8, 249.0, 253.7, 251.2];
alfa=0.03 ; 
[ci_u , ci_delta , u_value , p_value , H]=TTest2D(X ,Y , 0 ,  alfa , 'left') ;

% masodik > elso -> elso < masodik => left
if(H==0) 
    fprintf("HAMIS : A gep a masodik napon nem tolt tobbet. | H == %d \n" , H) ;
else
     fprintf("IGAZ: A gep a masodik napon tobbet tolt. | H == %d  \n" , H) ; 
end

fprintf("\nMegbizhatosagi intervallum u ci_u = (%f , %f) .\n" , ci_u(1) , ci_u(2)) ; 
fprintf("Megbizhatosagi intervallum delta ci_delta = (%f , %f) .\n" , ci_delta(1) , ci_delta(2)) ; 
fprintf("u_value = %f\n" , u_value) ;
fprintf("p_value = %f\n\n" , p_value) ; 
