import { basename } from 'path';
import pool, { executeQuery } from './db.js';

export const insertMovie = (req, callback) => {
  const query = 'Insert into Movies values (NULL , ? , ? , ? , ? , ? );';
  const parameters = [req.fields.title, req.fields.release,
    req.fields.genres, basename(req.files.cover.path), req.fields.descr];
  pool.query(query, parameters, callback);
};

export const insertReview = (req, callback, result) => {
  const query = 'Insert into Reviews values (NULL ,? , ? , ? , ?);';
  const parameters = [req.fields.selecteduser, req.fields.selectedmovie,
    req.fields.rating, req.fields.rev];
  pool.query(query, parameters, callback, result);
};

export const insertReviewNew = (chunk) => {
  const query = 'Insert into Reviews values (NULL ,? , ? , ? , ?, ?, NULL);';
  return executeQuery(query, [chunk.user, chunk.id, chunk.rating, chunk.review, chunk.status]);
};

export const insertUser = (userData) => {
  const query = 'Insert into Users values (NULL,?,?,?);';
  return executeQuery(query, [userData.username, userData.cryptedpasswd, userData.class]);
};
