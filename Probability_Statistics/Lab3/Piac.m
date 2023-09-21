eset1 = 0;
eset2 = 0;

for i=1:10000
    n = 50;
    n_paradicsom = 50*20/100;
    n_uborka = 50*16/100;
    n_paprika = 50*24/100;
    n_hagyma = n - n_paradicsom - n_paprika - n_uborka;
    X = [1,2,3,4; n_paradicsom/n, n_uborka/n, n_paprika/n, 0];
    X(2,4) = 1 - sum(X(2,:));
    %uborka
    a = 0;
    %paprika
    b = 0; 
    %hagyma
    c = 0;
    for j=1:20
        foo = InversionBySequentialSearch(X,1,1);
        switch foo
            case 1
                n_paradicsom = n_paradicsom -1;
            case 2
                n_uborka = n_uborka -1;
                a = a + 1;
            case 3
                n_paprika = n_paprika - 1;
                b = b+1;
            case 4
                n_hagyma = n_hagyma - 1;
                c = c + 1;
        end
        n = n - 1;
        X = [1,2,3,4; n_paradicsom/n, n_uborka/n, n_paprika/n, 0];
        X(2,4) = 1 - sum(X(2,:));
    end
    if(b == 5 && c == 8 && a >=1)
        eset1 = eset1 + 1;
    end   
    
    
    %2.)
    
    n = 50;
    n_paradicsom = 50*20/100;
    n_uborka = 50*16/100;
    n_paprika = 50*24/100;
    n_hagyma = n - n_paradicsom - n_paprika - n_uborka;
    X = [1,2,3,4; n_paradicsom/n, n_uborka/n, n_paprika/n, 0];
    X(2,4) = 1 - sum(X(2,:));
    a=0;
    db =0;
    while a~=7
        foo=InversionBySequentialSearch(X , 1 , 1);
        db=db+1;
        n = n - 1;
        switch foo
            case 1
                n_paradicsom = n_paradicsom -1;
                a=a+1;
            case 2
                n_uborka = n_uborka -1;
            case 3
                n_paprika = n_paprika - 1;
            case 4
                n_hagyma = n_hagyma - 1;
        end
        X = [1,2,3,4; n_paradicsom/n, n_uborka/n, n_paprika/n, 0];
        X(2,4) = 1 - sum(X(2,:));
    end
    eset2 = eset2 + db;
end
fprintf('\na) paprika == 5 && hagyma == 8 && uborka >=1: %f%%\n', eset1/10000*100);
fprintf('b) 7. paradicsomhoz átlagosan: %f lepes\n\n', eset2/10000);



