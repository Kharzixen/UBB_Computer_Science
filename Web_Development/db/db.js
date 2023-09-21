import mysql from 'mysql';

const pool = mysql.createPool({
  connectionLimit: 10,
  database: 'moviesdb',
  host: 'localhost',
  port: 3306,
  user: 'user',
  password: '123456',
});

//  ebben a tablaban taroljuk a filmeket

export function executeQuery(query, options = []) {
  return new Promise((resolve, reject) => {
    pool.query(query, options, (err, res) => {
      if (err) {
        reject(new Error(`Error while running ${query}: ${err}`));
      }
      resolve(res);
    });
  });
}

export function executeQueryRetObject(query, options = []) {
  return new Promise((resolve, reject) => {
    pool.query(query, options, (err, res) => {
      if (err) {
        reject(new Error(`Error while running ${query}: ${err}`));
      }
      resolve(res[0]);
    });
  });
}

pool.query(`create table if not exists Movies (
  MovieID int NOT NULL AUTO_INCREMENT,
  Title varchar(30),
  ReleaseDate date,
  Genres varchar(50),
  Cover varchar(300),
  Description varchar(255),
  Primary key(MovieID));`, (err) => {
  if (err) {
    console.error(`Create table error: ${err}`);
    process.exit(1);
  } else {
    console.log('Table created successfully');
  }
});

//  Ebben a tablaban a reviewokat

pool.query(`create table if not exists Reviews (
  ReviewID int NOT NULL AUTO_INCREMENT,
  User varchar(30),
  MovieID int,
  Rating int,
  Review varchar(255),
  Status int,
  Admin varchar(60),
  Primary key(ReviewID));`, (err) => {
  if (err) {
    console.error(`Create table error: ${err}`);
    process.exit(1);
  } else {
    console.log('Table created successfully');
  }
});

// userek tabla

pool.query(`create table if not exists Users (
  UserID int NOT NULL AUTO_INCREMENT,
  Username varchar(50),
  Password varchar(255),
  Class int,
  Primary key(UserID));`, (err) => {
  if (err) {
    console.error(`Create table error: ${err}`);
    process.exit(1);
  } else {
    console.log('Table created successfully');
  }
});

export default pool;
