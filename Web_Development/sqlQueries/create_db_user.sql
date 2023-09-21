## letrehozzuk az adatbazist

create database if not exists MoviesDB;

## letrehozzuk a felhasznalot
USE MoviesDB;
create user 'user'@'localhost' identified by '123456';
grant all on *.* to 'user'@'localhost';
flush privileges;
