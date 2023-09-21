import { executeQuery } from './db.js';

export const removeReviewByID = (id) => {
  const query = 'delete from Reviews where ReviewID = ?';
  executeQuery(query, [`${id}`]);
};

export const removeReviewByID2 = (id) => {
  const query = 'delete from Reviews where ReviewID = ?';
  executeQuery(query, [`${id}`]);
};

export const removeMovieByID = (id) => {
  const query = 'delete from Movies where MovieID = ?';
  executeQuery(query, [`${id}`]);
};
