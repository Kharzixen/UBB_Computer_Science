n = 100000;
ke_1 = 0;
ke_2 = 0;

%lefuttatjuk n-szer a kiserletet
for i=1:n
   %alaphelyzet vazolasa
   nr_all = 30;
   nr_zsk = 10;
   nr_ceruza = 9;
   nr_filctoll = 11;
   
   h_zsk = 0;
   h_ceruza = 0;
   h_filctoll = 0;
   
   nr_huzasok = 16;
   %huzas szimulacioja
   for j=1:nr_huzasok
       p_zsk =  nr_zsk/nr_all;
       p_ceruza = p_zsk + nr_ceruza/nr_all;
       
       p = ULEcuyerRNG(1);
       if p>0 && p<p_zsk
           h_zsk = h_zsk + 1;
           nr_zsk = nr_zsk -1 ;
       else
           if p>=p_zsk && p<p_ceruza
               h_ceruza = h_ceruza + 1;
               nr_ceruza = nr_ceruza - 1;
           else
               if p>= p_ceruza && p<1
                   h_filctoll = h_filctoll + 1;
                   nr_filctoll = nr_filctoll - 1;
               end
           end
       end
       nr_all = nr_all - 1 ;
       
   end
    
   %huzas kiertekelese
   if h_zsk == 5 && h_filctoll <= 7
       ke_1 = ke_1 + 1;
   end
   
   if h_ceruza >= 3 && h_ceruza <6
       ke_2 = ke_2 + 1;
   end
end

fprintf('\na) Pontosan 5 zsirkreta es legfeljebb 7 filctoll: %.4f%%\n\n', ke_1/n*100)
fprintf('b) Legalabb harom, de kevesebb mint hat szines ceruza: %.4f%%\n\n', ke_2/n*100)

