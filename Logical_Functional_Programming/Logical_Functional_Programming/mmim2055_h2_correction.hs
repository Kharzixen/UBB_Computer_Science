import Data.Char

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


getIndex :: (Num t1, Eq t2) => t2 -> [t2] -> t1
getIndex x list = getIndex_ 1 x list
    where 
        getIndex_ _ _ [] = 0
        getIndex_ i x (x1:xs)
         | x == x1 = i
         | otherwise = getIndex_ (i+1) x xs

search _ [] = ('0',0)
search x (x1:xs)
  | getIndex x (snd x1) == 0 = search x xs 
  | otherwise = (fst x1, getIndex x (snd x1))
  
isRepresentable [] = True
isRepresentable (x:xs)
   | search x list == ('0',0) = False
   | otherwise = isRepresentable xs
     where list = [('1',"1"),('2', "aábc2"),('3', "deéf3"),('4', "ghií4"),('5', "jkl5"),('6', "mnoóöő6"),('7',"pqrs7"),('8', "tuúüűv8"),('9',"wxyz9"),('0',"+ 0"),('#',".,#"),('*',"AÁBCDEÉFGHIÍJKLMNOÓÖŐPQRSTUÚÜŰVWXZY")]

--b) Határozzuk meg egy mondat oldPhone kódját.

getRepresentation [] = []
getRepresentation (x:xs)
   | isRepresentable (x:xs) == False = error "This string can not be represented"
   | fst (search x list) == '*' = ('*',1):(search (toLower x) list):getRepresentation xs
   | otherwise = (search x list):getRepresentation xs
     where list = [('1',"1"),('2', "aábc2"),('3', "deéf3"),('4', "ghií4"),('5', "jkl5"),('6', "mnoóöő6"),('7',"pqrs7"),('8', "tuúüűv8"),('9',"wxyz9"),('0',"+ 0"),('#',".,#"),('*',"AÁBCDEÉFGHIÍJKLMNOÓÖŐPQRSTUÚÜŰVWXZY")]