n=10000 ; 
t1=0 ; 
t2=0 ; 

nr_repulo = 200;
nr_vonat = 500;
p_utazMod = [1,2;1/3, 2/3];  

eredm_1 = 0;
eredm_2_A = zeros(1,n);
eredm_2_L = zeros(1,n);
for i=1:n
    % repulo
    nr_jR = 200;
    nr_rA = 200*34/100;
    nr_rP = 200*18/100;
    nr_rL = 200*20/100;
    nr_rD = 200*28/100;
    
    % vonat
    nr_jV = 500;
    nr_vA = 500 * 12/100;
    nr_vP = 500 * 22/100;
    nr_vL = 500 * 28/100;
    nr_vD = 500 * 38/100;
    
    p_repulo = [1,2,3,4 ;nr_rA/nr_jR, nr_rP/nr_jR, nr_rL/nr_jR, 0];
    p_repulo(2,4) = 1-sum(p_repulo(2,1:3));
    p_vonat = [1,2,3,4; nr_vA/nr_jV, nr_vP/nr_jV, nr_vL/nr_jV, 0];
    p_vonat(2,4) = 1-sum(p_vonat(2,1:3));
    
    db = 0; %eladott jegyek szama
    db_d = 0; %daniaba szolo jegyek szama (repulo + vonat)
    while (db_d ~= 10)
       t = InversionBySequentialSearch(p_utazMod, 1, 1);
       switch t
           case 1
               jegy = InversionBySequentialSearch(p_repulo, 1, 1);
               nr_jR = nr_jR - 1;
               switch jegy
                   case 1                       
                       nr_rA = nr_rA - 1;
                   case 2
                       nr_rP = nr_rP - 1;
                   case 3
                       nr_rL = nr_rL - 1; 
                   case 4
                       nr_rD = nr_rD -1;
                       db_d = db_d + 1;                     
               end
               p_repulo = [1,2,3,4 ;nr_rA/nr_jR, nr_rP/nr_jR, nr_rL/nr_jR, 0];
               p_repulo(2,4) = 1-sum(p_repulo(2,1:3));
           case 2
               jegy = InversionBySequentialSearch(p_vonat, 1, 1);
               switch jegy
                   case 1
                       nr_vA = nr_vA - 1;
                   case 2
                       nr_vP = nr_vP - 1;
                   case 3
                       nr_vL = nr_vL - 1 ;                 
                   case 4
                       nr_vD = nr_vD - 1;
                       db_d = db_d + 1; 
               end
               nr_jV = nr_jV - 1;
               p_vonat = [1,2,3,4; nr_vA/nr_jV, nr_vP/nr_jV, nr_vL/nr_jV, 0];
               p_vonat(2,4) = 1-sum(p_vonat(2,1:3));
       end
       db = db + 1;
    end
    eredm_1 = eredm_1 + db;
    
    %b) alpont 
    
    nr_jR = 200;
    nr_rA = 200*34/100;
    nr_rP = 200*18/100;
    nr_rL = 200*20/100;
    nr_rD = 200*28/100;
    
    % vonat
    nr_jV = 500;
    nr_vA = 500 * 12/100;
    nr_vP = 500 * 22/100;
    nr_vL = 500 * 28/100;
    nr_vD = 500 * 38/100;
    
    p_repulo = [1,2,3,4 ;nr_rA/nr_jR, nr_rP/nr_jR, nr_rL/nr_jR, 0];
    p_repulo(2,4) = 1-sum(p_repulo(2,1:3));
    p_vonat = [1,2,3,4; nr_vA/nr_jV, nr_vP/nr_jV, nr_vL/nr_jV, 0];
    p_vonat(2,4) = 1-sum(p_vonat(2,1:3));
    
    db1=0;
    db2=0;
    for j=1:50
       t = InversionBySequentialSearch(p_utazMod, 1, 1);
       switch t
           case 1
               jegy = InversionBySequentialSearch(p_repulo, 1, 1);
               nr_jR = nr_jR - 1;
               switch jegy
                   case 1                       
                       nr_rA = nr_rA - 1;
                       db1 = db1+1;
                   case 2
                       nr_rP = nr_rP - 1;
                   case 3
                       nr_rL = nr_rL - 1;
                       db2 = db2 + 1;
                   case 4
                       nr_rD = nr_rD -1;                   
               end
               p_repulo = [1,2,3,4 ;nr_rA/nr_jR, nr_rP/nr_jR, nr_rL/nr_jR, 0];
               p_repulo(2,4) = 1-sum(p_repulo(2,1:3));
           case 2
               jegy = InversionBySequentialSearch(p_vonat, 1, 1);
               switch jegy
                   case 1
                       nr_vA = nr_vA - 1;
                       db1 = db1 + 1;
                   case 2
                       nr_vP = nr_vP - 1;
                   case 3
                       nr_vL = nr_vL - 1 ; 
                       db2 = db2 + 1;
                   case 4
                       nr_vD = nr_vD - 1;
               end
               nr_jV = nr_jV - 1;
               p_vonat = [1,2,3,4; nr_vA/nr_jV, nr_vP/nr_jV, nr_vL/nr_jV, 0];
               p_vonat(2,4) = 1-sum(p_vonat(2,1:3));
       end
    end
    eredm_2_A(i) = db1;
    eredm_2_L(i) = db2;
end
fprintf("a) Átlagosan %f jegyet kell venni.\n", eredm_1/n);
fprintf("b)\n   -Anglia várható érték: %f .\n", mean(eredm_2_A));
fprintf("   -Lengyelország várható érték: %f.\n", mean(eredm_2_L));
fprintf("   -A kettö egyuttes szamanak varhato erteke: %f.\n", mean(eredm_2_A + eredm_2_L));

