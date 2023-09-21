import Data.List

--1) 
--Határozzuk meg az N-edik Fibonacci-számot.
-- Számítsuk ki a 30-adik elemét a sornak. Mi történik, ha az 150-edik Fibonacci-számot szeretnénk meghatározni? 

fibonacci :: (Integral a) => a -> a
fibonacci 1 = 1
fibonacci 2 = 1
fibonacci n 
    | n > 2 = fibonacci(n-1) + fibonacci(n - 2)


--2)
--Határozzuk meg aFibonacci-számok (végtelen) listáját, 
--majd a TAKE függvényt használva határozzuk meg az első 30, majd az első 150 elemet. 

fibs:: [Integer]
fibs = 1 : 1 : zipWith(+) fibs (drop 1 fibs)


--3)
--Írjunk függvényt, mely visszaadja egy lista két legnagyobb elemét 
--(ne használjunk rendezést vagy listamódosítást igénylő műveleteket). 

twoLargest :: Ord a => [a] -> [a]
twoLargest [x, y]
 | x > y = [x, y]
 | otherwise = [y, x]

twoLargest (first : xs)
 | first > x = [first, x]
 | first <= x && first > y = [x, first]
 | otherwise = [x, y]
 where [x, y] = twoLargest (xs)


--4)
--Írjunk függvényt, mely összefésül két listát. A két listáról feltételezzük, hogy rendezettek 
--és legyen a kimenő lista is rendezett.

merge:: Ord a => [a] -> [a] -> [a]
merge [] [] = []

merge list [] = list

merge [] list = list

merge (x1 : xs1) (x2 : xs2)
 | x1 < x2 = (x1 : merge xs1 (x2 : xs2))
 | otherwise = (x2 : merge (x1 : xs1) xs2)


--5)
--Írjunk függvényt, mely egy listáról meghatározza, hogy palindróma-e: a lista ugyanaz, 
--mint a lista fordítottja (pl. a "lehel" igen, a "csato" nem). 

reverse_ :: [a] -> [a]
reverse_ list = rev_acc [] list
 where 
      rev_acc acc [] = acc 
      rev_acc acc (x:xs) = rev_acc(x : acc) xs


palindrome :: Eq a => [a] -> Bool
palindrome list
 | list == reverse list = True
 | otherwise = False 


--6)
--Töröljük egy lista minden K-adik elemét. 
deleteCount :: Integral t => t -> [a] -> t -> [a]
deleteCount _ [] _ = []
deleteCount k (x:xs) aux
 | aux `mod` k == 0 = deleteCount k (xs) (aux + 1)
 | otherwise = (x : deleteCount k (xs) (aux + 1))

deleteK:: Integral t => t-> [a] -> [a]
deleteK 0 list = list
deleteK _ [] = []
deleteK k list = deleteCount k list 1


--7)
--Valósítsuk meg a "run-length encoding" algoritmust Haskell-ben: egy redundáns - sok egyforma elemet tartalmazó - 
--listát úgy alakítunk kompakt formába, hogy az ismétlődő elemek helyett egy párost tárolunk, ahol az első az elem, a
--második a multiplicitás.
--Például
--kompakt(["a","a","a","c","c","b"]) -> [("a",3),("c",2),("b",1)]
--Írjuk meg a kódokat úgy, hogy a listát csak egy alkalommal járjuk be.

compact1 :: Eq a => [a] -> [(a,Int)]
compact1 list = [(head x, length x)| x <- group list]

rle :: Eq a => [a] -> [(a,Int)]
rle list = foldr code [] list
      where code c []         = [(c,1)]
            code c ((x,n):ts) | c == x    = (x,n+1):ts
                              | otherwise = (c,1):(x,n):ts


--8)
--Eratosztenész szitája egy módszer, mellyel az összes prím listáját létre lehet hozni.
--A módszer a következő: a [2,..] listával indulva, mindig prímnek tekintjük a lista fejét, majd a szitát alkalmazzuk arra a listára, melyből kiszűrtük a lista fejének (először a kettőnek) a többszöröseit.

--    Írjunk egy függvényt, mely kiszűri egy szám többszörösét egy listából
--    kiszur.
--    Írjuk meg a szitát, alkalmazva a kiszur függvényt.
--    szita.
--    Implementáljunk egy függvényt, mely a prímszámok közül kiválasztja az N-ediket
--    valaszt.

eliminate :: Integral a => a -> [a] -> [a]
eliminate _ [] = []

eliminate n (x : xs)
 | x `mod` n == 0 = eliminated
 | otherwise = (x : eliminated)
 where eliminated = eliminate n xs

--  Írjuk meg a szitát, alkalmazva a kiszur függvényt.

sieve :: Integral a => [a] -> [a]
sieve (x : xs) = (x : sieved)
 where eliminated = eliminate x xs
       sieved = sieve eliminated

--   Implementáljunk egy függvényt, mely a prímszámok közül kiválasztja az N-ediket

choose :: Integral a => Int -> a
choose n = sieve [2,3..] !! (n-1)


--  Keressük meg bizonyos számok egyedi többszöröseinek összegét egészen  egy felső korlátig (azt kizárva).
--  Pl. Ha felsoroljuk az összes 20 alatti természetes számot, amelyek 3 vagy 5 többszörösei, akkor 3, 5, 6, 9, 10, 12, 15 és 18-at kapunk.
--  Ezeknek a többszöröseknek az összege 78.
--  megold 20 [3, 5] == 78

solve :: Integral a => a -> [a] -> a
solve n list =  sum (nub [x | x <- [1,2..n-1], y <- list, x `mod` y == 0 ])