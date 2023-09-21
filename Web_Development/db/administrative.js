import { executeQuery } from './db.js';

export const grantAdminForUser = (id) => {
  const query = 'UPDATE Users SET Class = 2 WHERE (UserID = ?)';
  return executeQuery(query, [id]);
};

export const denyAdminForUser = (id) => {
  const query = 'UPDATE Users SET Class = 1 WHERE (UserID = ?)';
  return executeQuery(query, [id]);
};
