import pool, { executeQuery, executeQueryRetObject } from './db.js';

export const findMovieIDs = (callback) => {
  const query = 'Select MovieID from Movies';
  pool.query(query, callback);
};

export const findMovies = (callback) => {
  const query = 'Select * from Movies';
  pool.query(query, callback);
};

export const getMovieWithID = (id, callback) => {
  const query = 'Select * from Movies where MovieID = ?';
  pool.query(query, [`${id}`],  callback);
};

export const getReviews = (id, callback) => {
  const query = 'Select * from Reviews where MovieID = ?';
  pool.query(query, [`${id}`], callback);
};

export const findUsers = async (callback) => {
  const query = 'Select * from Users';
  pool.query(query, callback);
};

export const findUsersNew = () => {
  const query = 'Select * from Users';
  return executeQuery(query);
};

export const getMovieWithIDNew = (id) => {
  const query = 'Select * from Movies where MovieID = ?';
  return executeQueryRetObject(query, [`${id}`]);
};

export const getReviewsNew = (id) => {
  const query = 'Select * from Reviews where MovieID = ?';
  return (executeQuery(query, [`${id}`]));
};

export const findMovieIDsNew = () => {
  const query = 'Select MovieID from Movies';
  return executeQuery(query);
};

export const getMoviesWithFilter = (chunk) => {
  const query = 'Select * from Movies where Title like concat(\'%\',IFNULL(?,Title),\'%\') and Genres like concat(\'%\', IFNULL(?,Genres),\'%\') and ReleaseDate >= IFNULL(?,ReleaseDate) and ReleaseDate <= IFNULL(?,ReleaseDate);';
  return executeQuery(query, [chunk.searchtitle,
    chunk.searchgenre, chunk.minrelease, chunk.maxrelease]);
};

export const getUser = (username, passwd) => {
  const query = 'Select * from Users where Username = ? and Password = ?;';
  return executeQuery(query, [username, passwd]);
};

export const getUserByID = (id) => {
  const query = 'Select * from Users where UserID = ?;';
  return executeQueryRetObject(query, [id]);
};

export const getUsersWithName = (username) => {
  const query = 'Select * from Users where Username = ?';
  return executeQuery(query, [username]);
};

export const getReviewsOfUser = (user) => {
  const query = 'Select * from Reviews join Movies on Reviews.MovieID = Movies.MovieID where Reviews.User = ?';
  return executeQuery(query, [user]);
};

export const GetAllMovies = () => {
  const query = 'Select * from Movies';
  return executeQuery(query);
};

export const GetAllReviews = () => {
  const query = 'Select * from Reviews';
  return executeQuery(query);
};

export const getCommentsWithFilter = (title, acc) => {
  const query = 'Select * from Reviews join Movies on Reviews.MovieID = Movies.MovieID where Movies.Title like concat(\'%\',IFNULL(?,Movies.Title),\'%\') and Reviews.Status = IFNULL(?,Reviews.Status)';
  return executeQuery(query, [title, acc]);
};

export const getUsersWithFilter = (name, userclass) => {
  const query = 'Select * from Users where Username like concat(\'%\',IFNULL(?,Username),\'%\') and Class = IFNULL(?, Class)';
  return executeQuery(query, [name, userclass]);
};
