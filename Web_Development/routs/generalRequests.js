import express from 'express';
import * as selects from '../db/selects.js';
import { GetUsernameFromToken, GetUserClassFromToken } from '../auth/auth.js';

// general acces point i.e index, user profile, logn and register acces point etc.

const generalRouter = express.Router();

// main page acces router
generalRouter.get(['/', '/index', '/index.html'], (req, res) => {
  const user = GetUsernameFromToken(req.cookies.token);
  const userclass = GetUserClassFromToken(req.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
  }
  selects.findMovies((err, movies) => {
    if (err) {
      res.status(500).render('error', { message: `${err}`, admin });
    } else if (user === '') {
      res.status(200).render('films', {
        movies, loggedin: false, user, admin,
      });
    } else {
      res.status(200).render('films', {
        movies, loggedin: true, user, admin,
      });
    }
  });
});

// user profile with user rights verification
generalRouter.get('/myprofile', async (req, res) => {
  const admin = (GetUserClassFromToken(req.cookies.token) === 2);
  if (GetUserClassFromToken(req.cookies.token) === 1
   || GetUserClassFromToken(req.cookies.token) === 2) {
    const reviews = await selects.getReviewsOfUser(GetUsernameFromToken(req.cookies.token));
    res.status(200).render('userprofile', {
      loggedin: true,
      admin,
      username: GetUsernameFromToken(req.cookies.token),
      reviews,
    });
  } else {
    res.status(200).render('userprofile', {
      loggedin: false, admin, username: null, reviews: null,
    });
  }
});

generalRouter.get('/login', (req, res) => {
  const userclass = GetUserClassFromToken(req.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
  }
  res.status(200).render('login', { msg: '', admin });
});

generalRouter.get('/register', (req, res) => {
  const userclass = GetUserClassFromToken(req.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
  }
  res.status(200).render('register', { msg: '', admin });
});

// admin function: listing all users
generalRouter.get('/users', async (req, res) => {
  const userclass = GetUserClassFromToken(req.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
  }
  if  (admin) {
    try {
      const users = await selects.findUsersNew();
      res.status(200).render('users', { users, admin });
    } catch (err) {
      res.status(500).render('error', { message: err, admin: true });
    }
  } else {
    res.status(500).render('error', { message: 'No authorization', admin: false });
  }
});

// admin panel
generalRouter.get('/admin', async (req, res) => {
  if (GetUserClassFromToken(req.cookies.token) === 2) {
    res.status(200).render('admin', {
      admin: true, moviesPanel: false, commentsPanel: false, movies: null, reviews: null,
    });
  } else {
    res.status(500).render('error', { message: 'No authorization', admin: false });
  }
});

export default generalRouter;
