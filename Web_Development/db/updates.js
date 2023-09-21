import { executeQuery } from './db.js';

export const approveComment = (id, admin) => {
  const query = 'update Reviews set Status = 2, Admin = ? where ReviewID = ?';
  executeQuery(query, [admin, id]);
};
export const refuseComment = (id, admin) => {
  const query = 'update Reviews set Status = -1, Admin = ? where ReviewID = ?';
  executeQuery(query, [admin, id]);
};
