import Data.List
import Data.Char

-- 1)
--Írjunk egy kódoló algoritmust, ami egy string-et kódol, az alábbi módon.
-- - kiszűrjük a szóközöket
-- - kisbetűsítünk
-- - egy m széles négyszöget alkotunk a szövegből

-- pl. "Alma a Fa aLatt" m=5 ->
-- "almaa"
-- "faala"
-- "tt   "
-- - majd, oszloponként olvassuk vissza a négyzet tartalmát:
-- "aftlatmaalaa"
-- - végül, c méretű darabokra osztjuk ezt a szöveget, szóközökkel elválasztva:
-- c=5 esetén, az eredmény: "aftla tmaal aa"

cutSpace x = filter (/=' ') x

lowerString = \x -> map toLower (cutSpace x)

splitEvery _ [] = []
splitEvery n xs = as : splitEvery n bs 
  where (as,bs) = splitAt n (lowerString xs)
  
concatText n x = concat (transpose (splitEvery n x))

addSpace n c h xs
    | length xs == h = addSpace n c h (concatText n xs)
    | length xs <= c = xs
    | otherwise = (take c xs ++ " " ++ addSpace n c h (drop c xs))



-- 2)
--Modellezzük a régi - nyomógombos - mobilt, ahol egy üzenetet úgy írtunk, hogy minden betűhöz egyszer vagy többször nyomtunk meg adott gombot. Az alábbiakban a gombokat adjuk meg, asszociálva a gomb kimenetével ha egyszer, kétszer ... van megnyomva (nevezzük oldPhone kódolásnak):
--1 - "1"
--2 - "aábc2"
--3 - "deéf3"
--4 - "ghií4"
--5 - "jkl5"
--6 - "mnoóöő6"
--7 - "pqrs7"
--8 - "tuúüűv8"
--9 - "wxyz9"
--0 - "+ 0"
-- * - MOD_C
-- # - ".,#"
--A forráskódban a gombokhoz tartozó karaktereket csak a következő formátumban lehet megadni: ["1", "aábc2", "deéf3", "ghií4", ..., "+ 0", ".,#"] (A * karakter hozzáadása a listához opcionális)
--A fenti kódolásnál a nagybetűket a "*" módosítóval tudjuk elérni, melyet az illető szám kódja előtt nyomunk meg. Például az "Alma" leírásának a szekvenciája: "*255562" -> [('*',1),('2',1),('5',3),('6',1),('2',1)]
--Feladat:

--a) Adjuk meg a függvényt, mely egy mondatra - Sztring-re - megmondja, ogy ábrázolható-e az oldPhone kódolásban. Például a "Lehel! 2+4=6" nem ábrázolható.

isValid character
 | character `elem` ['a'..'z'] = True
 | character `elem` ['A'..'Z'] = True
 | character `elem` ['0'..'9'] = True
 | character `elem` "áéíóöőúüűÁÉÍÓÖŐÚÜŰ+ .,#" = True
 | otherwise = False

validatePhoneString sentence = null [ x | x <- sentence, not (isValid x)]

--b) Határozzuk meg egy mondat oldPhone kódját.

isCapital character
 | character `elem` ['A'..'Z'] = True
 | character `elem` "ÁÉÍÓÖŐÚÜŰ" = True
 | otherwise = False

getPos' _ _ [] = -1

getPos' pos character (x:xs)
 | character == x = pos
 | otherwise = getPos' (pos+1) character xs

getPos character list = (getPos' 1 character list)

-- get encoding of a valid character

getCode_lower character
 | character == '1' = ('1', 1)
 | character `elem` "aábc2" = ('2', (getPos character "aábc2"))
 | character `elem` "deéf3" = ('3', (getPos character "deéf3"))
 | character `elem` "ghií4" = ('4', (getPos character "ghií4"))
 | character `elem` "jkl5" = ('5', (getPos character "jkl5"))
 | character `elem` "mnoóöő6" = ('6', (getPos character "mnoóöő6"))
 | character `elem` "pqrs7" = ('7', (getPos character "pqrs7"))
 | character `elem` "tuúüűv8" = ('8', (getPos character "tuúüűv8"))
 | character `elem` "wxyz9" = ('9', (getPos character "wxyz9"))
 | character `elem` "+ 0" = ('0', (getPos character "+ 0"))
 | character `elem` ".,#" = ('#', (getPos character ".,#"))
 | otherwise = (' ', 0)

getCode_upper character
 | character `elem` "AÁBC" = [('*', 1),('2', (getPos character "AÁBC"))]
 | character `elem` "DEÉF" = [('*', 1),('3', (getPos character "DEÉF"))]
 | character `elem` "GHIÍ" = [('*', 1),('4', (getPos character "GHIÍ"))]
 | character `elem` "JKL" = [('*', 1),('5', (getPos character "JKL"))]
 | character `elem` "MNOÓÖŐ" = [('*', 1),('6', (getPos character "MNOÓÖŐ"))]
 | character `elem` "PQRS" = [('*', 1),('7', (getPos character "PQRS"))]
 | character `elem` "TUÚÜŰV" = [('*', 1),('8', (getPos character "TUÚÜŰV"))]
 | character `elem` "WXYZ" = [('*', 1),('9', (getPos character "WXYZ"))]
 | otherwise = [(' ', 0),(' ', 0)]

--process string
processPhoneString [] = []

processPhoneString (x:xs)
 | isCapital x = (getCode_upper x) ++ (processPhoneString xs)
 | otherwise = (getCode_lower x) : (processPhoneString xs)

--entry point
oldPhone phoneString
 | validatePhoneString phoneString = processPhoneString phoneString
 | otherwise = []



-- 3)
-- Az until függvény használatával számítsuk ki a Haskell valós precizitását a kettes számrendszerben. 
-- A precizitás a kettőnek az a legnagyobb negatív hatványa, mely kettővel osztva nullát eredményez.

eps = until (\(x, k) -> x / 2 == 0) (\(x,k)->(x/2, k+1)) (1, 0)



-- 4)
-- Az until függvény használatával határozzuk meg egy pozitív szám természetes alapú logaritmusának - ln(y)-nek - az értékét. 
-- Használjuk a következő sorbafejtést:
--   ln(1+x) = - sum_{k,1,inf} (-x)^k/k
-- Írjuk úgy a kódot, hogy minél hatékonyabb legyen a függvény. Alakítsuk át a divergens sorozatokat a ln(y)=-ln(1/y)összefüggéssel (amely akkor kell, ha |x|>=1). 

calculate [x, sum, k] = [x, sum + (((-x+1)**k) / k), k+1]

condition [_,_,k]
  | k > 100 = True
  | otherwise = False

ln_ :: (Floating a, Ord a) => a->[a]  
ln_ x
  | (abs x) >= 1 = (ln_ (1/x))
  | otherwise = until condition calculate [x,0,1]

ln x = (ln_ x) !! 1
  


--  5)
--  A cumul_op függvény implementálása:
--  Írjunk függvényt, mely egy listából és egy operátorból azt a listát
--  állítja elő, mely egy pozíciójának a k-adik eleme a bemenő lista első
--  k elemének az op szerinti összetevése.

cumul_op' _ _ [] = []

cumul_op' kezdo f (elso : tobbi) = (ujElso : (cumul_op' ujElso f tobbi))
 where ujElso = f kezdo elso

cumul_op _ [] = []

cumul_op f (elso : tobbi) = (elso : cumul_op' elso f tobbi)



--6
--A bináris fák ábrázolásához tekintsük a következő típust:

--data BinFa a =
--   Nodus (BinFa a) a (BinFa a)
--   | Level

--mely egy bináris fát ábrázol. A következőkben a fákat rendezett keresési fáknak tekintjük: a nódusban található elem mindig nagyobb, mint a bal oldali fa összes eleme és kisebb a jobb oldali fa összes eleménél.
--Írjuk meg a következő függvényeket:

--    A beszur függvényt, mely egy bináris fába szúr be egy elemet.
--    A listából függvényt, egy számlistát alakít át bináris fává.
--    A torol függvényt, mely egy bináris fából egy elemet töröl. Használjuk a MayBe típust a hibakezelésre.

data BinFa a = Nodus (BinFa a) a (BinFa a) | Level
   deriving Show

beszur Level x = Nodus Level x Level
beszur (Nodus bal a jobb) x
   | x == a = Nodus bal a jobb
   | x < a = Nodus (beszur bal x) a jobb
   | x > a = Nodus bal a (beszur jobb x)
   
listabol list = foldl (\ fa x -> beszur fa x) Level list

baloldali (Nodus Level a _) = a
baloldali (Nodus bal _ _) = baloldali bal

torolDupl (Nodus bal a jobb) x
  | x == a = torol_ (Nodus bal a jobb)
  | x < a = (Nodus (torolDupl bal x) a jobb)
  | x > a = (Nodus bal a (torolDupl jobb x))

torol_ (Nodus Level a jobb) = jobb
torol_ (Nodus bal a Level) = bal
torol_ (Nodus bal a jobb) = (Nodus bal a0 (torolDupl jobb a0))
                 where 
				     a0 = baloldali jobb

torolNod ::(Ord a, Eq a) => (BinFa a) -> a -> (Maybe (BinFa a))
torolNod Level _ = Nothing
torolNod (Nodus bal a jobb) x
  | x == a = Just (torol_ (Nodus bal a jobb))
  | x < a = case (torolNod bal x) of
               Just uj_bal -> Just (Nodus uj_bal a jobb)
               Nothing -> Nothing
  | x > a = case (torolNod jobb x) of
               Just uj_jobb -> Just (Nodus bal a uj_jobb)
               Nothing -> Nothing
			   


-- 7)
-- A komplex számok a+i.b alakúak, ahol a a valós része, b az imaginárius része a számnak, az i meg a -1 négyzetgyöke. 
-- Definiáljuk a C komplex szám adattípust. Írjuk meg a show, az aritmetikai műveleteknek (+,-,*,/,abs) a Haskell kódját.

data Imaginary = Imaginary { re :: Double, im :: Double }

instance Show Imaginary where
 show (Imaginary re im) = ((show re) ++ " + " ++ (show im) ++ "*i")

instance Num Imaginary where
 (Imaginary re1 im1) + (Imaginary re2 im2) = Imaginary (re1 + re2) (im1 + im2)
 (Imaginary re1 im1) - (Imaginary re2 im2) = Imaginary (re1 - re2) (im1 - im2)
 (Imaginary re1 im1) * (Imaginary re2 im2) = Imaginary (re1*re2 - im1*im2) (re1*im2 + re2*im1)
 abs (Imaginary re im) = Imaginary (sqrt (re*re + im*im)) 0

instance Fractional Imaginary where
      (Imaginary re1 im1) / (Imaginary re2 im2) = Imaginary ((re1*re2 + im1*im2) / (re2*re2 + im2*im2)) ((im1*re2 - re1*im2) / (re2*re2 + im2*im2))


freq list1 list2 = map (\x -> (x, (calculate x list2))) list1
  where 
    calculate x list2 = length (filter (\y -> y == x) list2)

calculate x list2 = length (filter (\y -> y == x) list2)