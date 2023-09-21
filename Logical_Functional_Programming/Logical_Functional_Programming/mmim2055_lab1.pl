%1:
listaosszege([] ,0) .

listaosszege([H1|T] , O):-
    listaosszege(T , Maradek) ,
    O is Maradek+H1 .

%2:
kszorHead(1 , L , L).
kszorHead(S , [H|T] , L):-
    S>1,
    S_ is S -1,
    kszorHead(S_ , [H , H|T] , L) .

kszor(K , [X] , L):-
    kszorHead(K , [X] , L).

kszor(K , [H|T] , L):-
    kszor(K , T , L1) ,
    kszorHead(K , [H |L1] , L).


%3:
generateBetween1(A , A  , [A]) .

generateBetween1(A , B , [B|T]):-
    A =< B ,
    C is B-1 ,
    generateBetween1(A , C , T) .


generateBetween(A , B , L):-
    generateBetween1(A , B , Foo),
    reverse(Foo ,L).


%4:
inv([] , L , L).
inv([H|T] , L , Foo):-
    inv(T , [H|L] , Foo) .
invertal(L1 , L2):-
    inv(L1 , [] , L2) .


%5:
%egyik valtozat , masik valtozat :
%
torolkValtozo([] , [] , _ , _) .

torolkValtozo([_|T] , L , K , I):-
    I mod K =:=0 ,
    I2 is I +1 ,
    torolkValtozo(T , L , K , I2) .

torolkValtozo([H|T] , [H|L] , K , I):-
    I mod K =\= 0 ,
    I2 is I+1 ,
    torolkValtozo(T , L , K , I2) .

torolk(L1 , K , L2):-
    torolkValtozo(L1 , L2 , K , 1) .


%6:
szamlalTorol([], _, 0, []).

szamlalTorol([H|T], VizsgElem, Db1, L) :-
    H = VizsgElem,
    szamlalTorol(T, VizsgElem, Db2, L),
    Db1 is Db2+1.

szamlalTorol([H|T], VizsgElem, Db, [H|T]) :-
    H \= VizsgElem,
    Db is 0.

kompakt([], []).

kompakt([H|T], [[H, Db2]|L2]) :-
    szamlalTorol(T, H, Db1, L1),
    Db1 > 0,
    Db2 is Db1+1,
    kompakt(L1, L2).

kompakt([H|T], [H|L]) :-
    szamlalTorol(T, H, Db, _),
    Db = 0,
    kompakt(T, L).


%7:
megoldasok([S,E,N,D], [M,O,R,E], [M,O,N,E,Y]) :-
    permutation([0,1,2,3,4,5,6,7,8,9], [D,E,M,N,O,R,S,Y,_,_]),
    S \= 0,
    M \= 0,
    M*10000 + O*1000 + N*100 + E*10 + Y =:= S*1000 + E*100 + N*10 + D + M*1000 + O*100 + R*10 + E .
