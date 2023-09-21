import Data.List

-- 4
-- vezesd le a tipusat
-- egy vegtelen listat hoz letre ahol b-c kulombseggel nonek a szamok
a :: Num t => t -> t -> [t]
a b c = b : a c (b + c)


-- 5. dropWhile
dropWhile' _ [] = []
dropWhile' felt (x:xs) 
    | not (felt x) = (x:xs)
    | True = dropWhile' felt xs

-- 6. keresesi fa
data Fa a = Nodus (Fa a) a (Fa a)
        | Level

elemetAd:: (Ord a) => (Fa a) -> a -> (Fa a)
elemetAd Level value = (Nodus Level value Level)
elemetAd (Nodus a b c) value 
    |  value < b = Nodus (elemetAd a value) b c
    |  value > b = Nodus a b (elemetAd c value)

-- 7. halmazositani
listToSet list = (map head) $ group $ sort list
metszet xs ys = interSection (listToSet xs) (listToSet ys)
    where
        interSection list [] = []
        interSection [] list = []
        interSection (x:xs) list2
            | elem x list2 = x:(interSection xs list2)
            | True = interSection xs list2

halmazosit [] = []
halmazosit (x:xs)
    |x `elem` xs = halmazosit xs
    |otherwise = (x: halmazosit xs)

    

-- 8. Magasabbrendu fg nelkul
any':: (a -> Bool) -> [a] -> Bool
any' _ [] = False
any' felt (x:xs) 
    | felt x = True
    | otherwise = any' felt xs

-- Magasabbrendu fg-el 
any2:: (a -> Bool) -> [a] -> Bool
any2 felt list = foldr (||) False $ map felt list


-- 9. !! implementalas fuggvenykent
ind:: [a] -> Int -> a
ind [] n = error "index too high"
ind (x:_) 0 = x
ind (x:xs) n = ind xs (n - 1)

(!):: [a] -> Int -> Maybe a
[] ! n = Nothing
(x:_) ! 0 = Just x
(x:xs) ! n = xs ! (n - 1)

-- 10.
(~~)::[a] -> [Int] -> [a]
list ~~ [] = []
list ~~ (x:xs) = (list!!x):(list ~~ xs)

-- 11. all cond lista
all':: (a -> Bool) -> [a] -> Bool
-- all' cond = foldr (&&) True . map cond
all' cond list = foldr (&&) True $ map cond list


-- 12. Racionalis
-- ?
data Q = Q { 
    szam::Integer, 
    nev::Integer 
} deriving Show

-- thd3 (x, y, z) = z
-- hanyszor a b = thd3 $ until stop iter (a, b, 1)
--     where a = (min a b)
--           b = (max a b) 
--           stop (a, b, _) = a == b
--           iter (a, b, iter) = (a, b - a, iter + 1) 
          

egyszerusit:: Q -> Q
egyszerusit (Q szam nev) = (Q (szam `div` oszto) (nev `div` oszto)) 
    where oszto = gcd szam nev
-- 13.
-- f (x:xs) = x : [y | y <- (f xs), (y rem x) <> 0]
-- f:: [a] -> [a]
-- f [] = []
-- f (x:m) = x: [y | y <- (f m), (y rem x) <> 0]



-- ugyan az mint az elso
-- 14. fg b c = b : fg c (b + c)
fg:: Real a => a -> a -> [a]
fg b c
    | b >= 2 = b : fg c (b + c)
    | otherwise = b : fg c (b + c)
    
-- 16. 
foldlr':: a -> (a -> a -> a) -> [a] -> a
foldlr' a0 _ [] = a0
foldlr' a0 op (x:xs) = foldlr' (op a0 x) op xs

foldrerr' a0 op list = foldlr' a0 (flip op) list

foldl_hazi :: (b -> a -> b) -> b -> [a] -> b 
foldl_hazi f acc [] = acc 
foldl_hazi f acc (x:xs) = foldl_hazi f (f acc x) xs

-- 17.
fst3:: (a, b, c) -> a
fst3 (x,y,z) = x
e = fst3 $ until felt szamol (0, 1, 1)
    where felt (osszeg, k, i) = abs(osszeg - (fst3 (szamol (osszeg, k, i)))) < 0.00001
          szamol (osszeg, k, i) = (osszeg + (1 / k), k * i, i + 1)

-- 18.
insertAt value 0 list = value:list
insertAt _ i [] = []
insertAt value i (x:xs) = x : (insertAt value (i - 1) xs)

permList:: [a] -> [[a]]
permList [] = [[]]
permList (x:xs) = [ insertAt x i ys | i<-[0..(length xs)], ys <- permList xs ]

-- egyeb [a,b,c] = [ insertAt a i ys | i<-[0..2], ys <- egyeb [b,c]]
--      egyeb [b,c] = [ insertAt b i ys | i<-[0..1], ys <- egyeb [c]]
--          egyeb [c] = [ insertAt c i ys | i<-[0..0], ys <- egyeb []]
--          i<-0, ys=[] -> [c]
--      i<-0,1, ys = [c] [[b, c], [c, b]]
-- i <- 0,1,2 ys=[[b, c], [c, b]]    [[a, b, c], [c, b]]


-- 19.
fst2 (x, y) = x
egyperkob = fst2 $ until felt iter (0, 1)
  where
    felt (osszeg, x) = abs (osszeg - (fst2 $ iter (osszeg, x))) < 0.00000001
    iter (osszeg, x) = (osszeg + 1/(x*x*x), x+1)


freq list1 list2 = map (\x -> (x, (calculate x list2))) list1
  where 
    calculate x list2 = length (filter (\y -> y == x) list2)


f a b c = a (init b) (init c) : f a (tail b) (tail c)

i True x _ = x
i _ _ x = x

j (x:xs) = foldr(\x y -> i (x > y) x y) x xs