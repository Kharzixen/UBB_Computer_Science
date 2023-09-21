import express from 'express';
import { LogoutUser } from '../auth/auth.js';
import * as administrative from '../db/administrative.js';
import { getUserByID } from '../db/selects.js';

const administrationRouter = express.Router();

// administrative functions about admin rights

administrationRouter.post('/grant_admin', async (req, res) => {
  const user = req.fields.id;
  try {
    await administrative.grantAdminForUser(user);
    const userData = await getUserByID(user);
    await LogoutUser(userData.Username);
    res.status(200).redirect('/users');
  } catch (err) {
    res.status(500).render('err', { message: err, admin: true });
  }
});

administrationRouter.post('/deny_admin', async (req, res) => {
  const user = req.fields.id;
  try {
    await administrative.denyAdminForUser(user);
    const userData = await getUserByID(user);
    await LogoutUser(userData.Username);
    res.status(200).redirect('/users');
  } catch (err) {
    res.status(500).render('err', { message: err, admin: true });
  }
});

export default administrationRouter;
