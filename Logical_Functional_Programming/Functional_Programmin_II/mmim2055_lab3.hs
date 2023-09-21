import Data.Maybe

-- BTK: foldl esetén az elso megadott parameter a reszeredmeny, a masodk a tag
--    : foldr esetén az elso a tag, a masodik az addigi részeredmény 

-- 1. Alapfüggvények hajtogatással
-- (5 pont)

-- Implementáljátok a funkcionális nyelveknek alábbi alapfüggvényeit, hajtogatást alkalmazva:

-- minimum :: Ord a => [a] -> a
-- Megkeresi egy lista legkisebb elemét.
-- minimum [3,4,1,2] ⇒ 1

myMin :: Ord a => [a] -> Maybe a
myMin [] = Nothing
myMin (x:xs) = Just $ foldr (\x y -> if x < y then x else y) x xs 


-- sum :: Num a => [a] -> a
-- Kiszámolja egy lista elemeinek az összegét.
-- sum [1..10] ⇒ 55

mySum :: Num a => [a] -> a
mySum list = foldl (+) 0 list


-- and :: [Bool] -> Bool
-- Listákkal dolgozó logikai és művelet (üres tömb igaz).
-- and [True, True, False] ⇒ False

myAnd :: [Bool] -> Bool
myAnd list = foldl (&&) True list


-- concat :: [[a]] -> [a]
-- Egy dupla mélységű listát kilapít.
-- concat ["a", "bb", "c"] ⇒ "abbc"


myConcat :: [[a]] -> [a]
myConcat list = foldl (++) [] list


-- (++) :: [a] -> [a] -> [a]
-- Összefűz két azonos típusú listát.
-- [1..5] ++ [7..10] ⇒ [1, 2, 3, 4, 5, 7, 8, 9, 10]

concatOperator :: [a] -> [a] -> [a]
concatOperator list1 list2 = foldr (:) list2 list1


-- length :: [a] -> Int
-- Kiszámolja egy listának a hosszát.
-- length [1..10] ⇒ 10

myLength :: [a] -> Int
myLength list = foldl (\n _ -> 1 + n) 0 list


-- reverse :: [a] -> [a]
-- Megfordít egy listát.
-- reverse "mittomen" ⇒ "nemottim"

myReverse :: [a] -> [a]
myReverse list = foldl (flip (:)) [] list


-- #-----------------------------------------------------------------------------------# --


-- 2. Feladatok hajtogatással (fold, scan)
-- (5 pont)

-- A fold, scan használatával:

-- 1. írd meg a beszúrásos rendezést (egy üres kezdeti tömbbe szúrja be egyesével az elemeket, mindegyiket a helyére).
-- isort [1,4,6,3,2,11] ⇒ [1, 2, 3, 4, 6, 11]

insert xs x = smallerOrEqual ++ [x] ++ greater where (smallerOrEqual, greater) = span (<x) xs

isort :: Ord a => [a] -> [a]
isort list = foldl insert [] list


-- 2. Írj egy függvényt, mely átalakít egy listával megadott bit-sorozatot egy egész számmá.
-- fromBinary [1, 0, 1, 1] ⇒ 11

-- https://www.geeksforgeeks.org/how-to-convert-from-binary-to-decimal/ 
-- solution 2 megoldást alkalmazva

fromBinary list = foldl step 0 list
    where step x y = (+) (y) ( x * 2 )


-- 3. Írj egy függvényt, mely kiértékel egy együtthatókkal megadott polinomot egy adott értékre.
-- polynomial [7, 2, 1, 3] 4 ⇒ 487

polynomial list val = foldl (\x s -> (val*x)+s) 0 list

-- 4. Számold ki egy lista elemeinek az összegét, a részeredményeket is megtartva!
-- sums [1, 3..19] ⇒ [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

sums list = tail $ scanl (+) 0 list

-- 5. Generáld a fibonacci számsorozatot.
-- fibs ⇒ [1, 1, 2, 3, 5, 8, 13, 21, ...]

fibs = 1 : scanl (+) 1 fibs