import Control.Monad
import Data.Either

--Mellau Márk-Máté
--533


--1) 

--Írjunk egy függvényt, mely egy pozitív N-re kiszámolja a számok összegét 1től N-ig. Például:
--sum 5 ⇒ 15

sum_ n = sum1 0 n 

sum1 x 0 = x
sum1 x n = sum1 (x+n) (n-1)


--Írjuk meg ennek egy kétparaméteres változatát mely N-től M-ig összeadja a számokat. Például:
--sum 1 3 ⇒ 6
--sum 6 6 ⇒ 6

sum2_ x y 
    | x < y = sum2 x y 0
    | otherwise = sum2 y x 0

sum2 x y s
    | x == y = (s+x)
    | otherwise = sum2 (x+1) y (s+x) 

-------------------------------------------------------------------------------------------------

--2) 2. Listák készítése

--Írjunk egy függvényt mely előállít egy listát 1-től N-ig a természetes számokból.
--create_list 3 ⇒ [1, 2, 3]

create_list n = create_list_aux n 1

create_list_aux n x 
    | n == x = [x] 
    | otherwise = x:create_list_aux n (x+1)

--Írjunk egy függvényt mely fordított sorrendben állítja elő az előző listát.
--reverse_create 3 ⇒ [3, 2, 1]

reverse_create 0 = []
reverse_create n = n:reverse_create(n-1)

-------------------------------------------------------------------------------------------------

--3) 3. Mellékhatások

--Írjunk függvényt, mely kiírja az összes természetes számot 1-től N-ig a képernyőre.
--Tipp: putStrLn-al lehet kiíratni, s ugye show-al String-gé alakítani.
list_to_string = unwords . map show

main1 :: IO ()
main1 = 
    do
        putStr "n = "
        input1 <- getLine 
        let n = (read input1 :: Int)
        let x = create_list n 
        putStrLn(list_to_string x)

--Írjunk egy függvényt, mely csak a párosakat írja ki.
--Tipp: Őrkifejezéseket használjatok.


create_list_even_only n = create_list_even_only_aux n 2

create_list_even_only_aux n x 
    | x >= n && (even n) = [n]
    | x >= n && not (even n) = []
    | otherwise = x:create_list_even_only_aux n (x+2)

main2 :: IO ()
main2 = 
    do
        putStr "n = "
        input1 <- getLine 
        let n = (read input1 :: Int)
        let x = create_list_even_only n 
        putStrLn(list_to_string x)

-------------------------------------------------------------------------------------------------

--4.) Egyszerű "adatbázis" listákkal

--Írjunk függvényeket adatbázis kezelésére: az adatbázist létrehozzák, 
--lehetővé teszik elemek beszúrását, keresést az adatok között, illetve elemek törlését.
--Implementáljuk az összes függvényt/rekurziót!

new = []

write list key value = 
    write_ list key value []

write_ [] key value acc = acc ++ [(key,value)]
write_ ((key1, value1):xs) key value acc
    | key1 == key = acc ++ [(key1, value)] ++ xs
    | otherwise = write_ xs key value ([(key1, value1)] ++ acc)


delete list key = delete_ list key []

delete_ [] _ acc = acc
delete_ ((key1, val1):xs) key acc 
    | key1 == key = acc ++ xs
    | otherwise = delete_ xs key ([(key1, val1)] ++ acc)


--kiértékelöfüggvény 
f = either (\l -> ("error", "not found")) (\r -> ("ok", r))
readVal [] key = f (Left key)
readVal ((key1, val1):xs) key
    | key1 == key = f (Right val1)
    | otherwise = readVal xs key


match [] value = []
match ((key, value1):xs) value 
    | value1 == value = key: (match xs value)
    | otherwise = match xs value

-------------------------------------------------------------------------------------------------

--5.) Listakezelés

--Írjunk függvényt, mely egy listából kiválogatja azon elemeket melyek kisebbek, mint egy adott szám.
--filter [1, 2, 3, 4, 5, 3, 0] 4 ⇒ [1, 2, 3, 3, 0]

filterSmaller [] _ = []

filterSmaller (x:xs) num
    | x < num = x:filterSmaller xs num
    | otherwise = filterSmaller xs num


--Írjunk függvényt, mely egy lista elemeinek sorrendjét megfordítja.
--reverse [1, 2, 3] ⇒ [3, 2, 1]

reverseList list = reverseList_ list []
    where 
        reverseList_ [] acc = acc
        reverseList_ (x:xs) acc = reverseList_ xs (x:acc)


-- "++" operator

reverseList2 [] = []
reverseList2 (x:xs) = reverseList2 xs ++ [x]

--Írj egy függvényt mely egy listákból álló listából egy egyszerű listát készít.
--concatenate [[1, 2, 3], [4], [5, 6]] ⇒ [1, 2, 3, 4, 5, 6]

concatLists [] = []
concatLists (x:xs) = x ++ concatLists xs

-------------------------------------------------------------------------------------------------

--6.) Rendezések

--Implementáljuk az alábbi két rendező algoritmust:

--Quicksort
--A lista feje a pivot/osztó elem. A listát kettéosztjuk aszerint, hogy az elemek kisebbek vagy nagyobbak az osztóelemnél. 
--Mindkét listát rekurzívan rendezzük, majd összefűzzük a két eredménylistát, az osztó elemet helyezve középre.

qsort [] = []
qsort (x:xs) = smaller ++ (x:greater)
    where
        smaller = qsort [e | e<-xs, e<x]
        greater = qsort [e | e<-xs, e>x]

--Mergesort
--Az eredeti listát kettéosztjuk fele-fele arányban, mindkét részlistát rekurzívan rendezzük, majd a kettőt összefésüljük.

merge [] [] = []
merge list [] = list
merge [] list = list
merge (x1 : xs1) (x2 : xs2)
 | x1 < x2 = (x1 : merge xs1 (x2 : xs2))
 | otherwise = (x2 : merge (x1 : xs1) xs2)


halve [] = ([],[])
halve [x]= ([x],[])
halve (x1:x2:xs) = (x1:xs1,x2:xs2)
    where
        (xs1,xs2) = halve xs


mergeSort [] = []
mergeSort [x]= [x]
mergeSort list = merge (mergeSort list1) (mergeSort list2)
    where
        (list1,list2) = halve list