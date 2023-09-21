%Mellau Mark-Mate
%523/1-es csoport
%Prolog lab2.


%1-------------------


deriv(sin(X) , X , cos(X)).

deriv(cos(X) , X , -sin(X)) .

deriv(X , X , 1):-! .

deriv(X^N , X , N*(X^N2)):-
    N2 is N-1.


deriv(A^X , X , N*(A^X)):-
    N is log(A) .

deriv(C , _ , 0):-
    atomic(C) .

deriv(F+G , X , DF+DG):-
    deriv(F,X,DF),
    deriv(G,X,DG).

deriv(F-G , X , DF-DF):-
    deriv(F,X,DF) ,
    deriv(G , X , DF).

deriv(F*G , X , DF*G+DG*F):-
    deriv(F,X,DF) ,
    deriv(G,X,DG) .

deriv(F/G , X , (DF*G-DG*F)/(G*G)):-
    deriv(F,X,DF),
    deriv(G,X,DG).


%2----------------------


simpl(_^0 , 1) .
simpl(1^_ , 1).

simpl(_*0, 0) .
simpl(0*_, 0).
simpl(1*X, X1) :- simpl(X, X1).
simpl(X*1, X1) :- simpl(X, X1).
simpl(0+X, X1) :- simpl(X, X1).
simpl(X+0, X1) :- simpl(X, X1).


simpl(X, X)       :- number(X) ; atom(X) .
simpl(X^Y , X^Y) :- ! .
simpl(X+Y, X1+Y1) :- simpl(X, X1), simpl(Y, Y1).
simpl(X-Y, X1-Y1) :- simpl(X, X1), simpl(Y, Y1).
simpl(X*Y, X1*Y1) :- simpl(X, X1), simpl(Y, Y1).
simpl(X/Y, X1/Y1) :- simpl(X, X1), simpl(Y, Y1).

%3------------------------

calcLen(List, N):- length(List,N).

listak_hossza([] , []) .
listak_hossza([H|T1] , [N-H|T2]):-
    calcLen(H , N ) ,
    listak_hossza(T1 , T2) .

listak_vissza([] , []).
listak_vissza([_-H | T1] , [H|T2]):-
    listak_vissza(T1 , T2).

lsort(L1 , L2):-
    listak_hossza(L1 , Foo) ,
    keysort(Foo , Aux) ,
    listak_vissza(Aux , L2) .



%4----------------------------


%4/2
filmek_szama(N):-
    aggregate_all(count , movie(_,_) , N).


%4/1

%al_pacino - abe_vigoda

kozosFilm(SZ1, SZ2, F) :-
    actor(F, SZ1, _),
    actor(F, SZ2, _),
    SZ1 \= SZ2.

kozosFilm(SZ1, SZ2, F) :-
    actress(F, SZ1, _),
    actress(F, SZ2, _),
    SZ1 \= SZ2.

kozosFilm(SZ1, SZ2, F) :-
    actor(F, SZ1, _),
    actress(F, SZ2, _).

kozosFilm(SZ1, SZ2, F) :-
    actress(F, SZ1, _),
    actor(F, SZ2, _).

joPartner(SZ1, SZ2) :-
    findall(X, kozosFilm(SZ1, SZ2, X), L),
    length(L, H),
    H > 1.


%5----------------------------

%1:

levelek_osszege(null , 0).
levelek_osszege(node(_ , null , null) , 1):-!.
levelek_osszege(node(_ , L , R) , I):-
    levelek_osszege(L , NL) ,
    levelek_osszege(R , NR) ,
    I is NL + NR  .

%2-------------------------------


preOrder(null, []).
preOrder(node(X, L, R), [X|Eredmeny]) :-
    preOrder(L, LT),
    append(LT , RT , Eredmeny),
    preOrder(R, RT).


inOrder(null, []).
inOrder(node(X, L, R), Eredmeny) :-
    inOrder(L,LS ),
    inOrder(R, RS),
    append(LS , [X|RS] , Eredmeny) .


postOrder(null , []).
postOrder(node(X , L , R) , Eredmeny):-
    postOrder(L , LS),
    postOrder(R ,RS) ,
    append(LS , RS , Foo),
    append(Foo,[X] , Eredmeny).












