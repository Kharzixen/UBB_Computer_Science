import Data.List
import Data.Function


-- 1. Alapfüggvények
-- Implementáljátok a funkcionális nyelveknek alábbi alapfüggvényeit:

-- a)
-- takeWhile :: (a -> Bool) -> [a] -> [a]
-- Visszatéríti egy lista elejéről az elemeket mindaddig, amíg egyik nem felel meg már egy adott feltételnek
-- takeWhile (<5) [1,2,3,4,5,6,5,4,3,2] ⇒ [1, 2, 3, 4]

myTakeWhile :: (a -> Bool) -> [a] -> [a]
myTakeWhile _ [] = []
myTakeWhile f (x:xs)
    | f x = x:myTakeWhile f xs
    | otherwise = []


-- b)
-- dropWhile :: (a -> Bool) -> [a] -> [a]
-- Levágja egy lista elejéről az elemeket mindaddig, amíg egyik nem felel meg már egy adott feltételnek, majd a többit visszatéríti.
-- dropWhile (<5) [1,2,3,4,5,6,5,4,3,2] ⇒ [5, 6, 5, 4, 3, 2]

myDropWhile :: (a -> Bool) -> [a] -> [a]
myDropWhile _ [] = []
myDropWhile f (x:xs)
    | f x  = myDropWhile f xs
    | otherwise = (x:xs)


-- c)
-- iterate :: (a -> a) -> a -> [a]
-- Egy végtelen listát készít, melynek adott kezdőértékből indul, és minden elem az előtte levő elemnek egy függvény alkalmazása.
-- take 10 (iterate (*2) 1) ⇒ [1, 2, 4, 8, 16, 32, 64, 128, 256, 512]

myIterate :: (a -> a) -> a -> [a]
myIterate f val = val:myIterate f (f val)

-- d)
-- all :: (a -> Bool) -> [a] -> Bool
-- Leellenőrzi, hogy egy lista minden eleme megfelel-e adott feltételnek.
-- all even [2,4..10] ⇒ True

myAll :: (a -> Bool) -> [a] -> Bool
myAll _ [] = True
myAll f (x:xs) 
    | f x = myAll f xs
    | otherwise = False

-- e)
--any :: (a -> Bool) -> [a] -> Bool
--Leellenőrzi, hogy egy listának létezik-e olyan eleme, mely megfelel adott feltételnek.
--any even [1..10] ⇒ True

myAny :: (a -> Bool) -> [a] -> Bool
myAny _ [] = False
myAny f (x:xs)
    | f x = True
    | otherwise = myAny f xs


-- 2. Funkcionális minták alkalmazásai
-- használjátok a magasabbrendű függvényeket --
-- (5p)

-- a)
-- deleteAll :: Eq a => a -> [a] -> [a]
-- deleteAll e list -- törli az összes 'e' elemet a 'list' listából.
-- Pl. deleteAll 'a' "almaafaalatt" = "lmfltt"

deleteAll :: Eq a => a -> [a] -> [a]
deleteAll what list = filter (\e -> e /= what) list


-- b)
-- countAll :: Eq a => a -> [a] -> Int
-- countAll e list -- megszámolja az 'e' elem előfordulását a 'list' listában.
-- Pl. countAll 'a' "almaafaalatt" = 6

countAll :: Eq a => a -> [a] -> Int
countAll element list = length(filter (==element) list)


-- c)
-- histogram ::  Eq a => [a] -> [(a,Int)]
-- histogram list -- a 'list' elem-gyakoriság párosait téríti vissza.
-- Pl histogram "almaafaalatt"  = [('a',6),('l',2),('m',1),('f',1),('t',2)]

histogram :: Eq a => [a] -> [(a,Int)]
histogram [] = []
histogram (x:xs) = (x, countAll x (x:xs)) : histogram (filter (/=x) xs)  


-- d)
-- permInv :: [Int] -> [Int]
-- permInv list -- visszatéríti a lista -- mint permutáció -- inverzét.
-- Pl. permInv [5,6,1,2,4,3] = [ 3, 4, 6, 5, 1, 2]
 
permInv list = map snd $ sort $  zip list [1..]