import express from 'express';
import { GetUserClassFromToken, GetUsernameFromToken } from '../auth/auth.js';
import * as selects from '../db/selects.js';

// filtering funtions with search forms (admin)

const filtersRouter = express.Router();

filtersRouter.get('/search_comment', async (req, res) => {
  if (GetUserClassFromToken(req.cookies.token) === 2) {
    let title = req.query.searchtitle;
    let acc = req.query.searchacceptance;
    if (acc === '') {
      acc = null;
    }
    if (title === '') {
      title = null;
    }
    console.log(acc);
    try {
      const reviews = await selects.getCommentsWithFilter(title, acc);
      res.status(200).render('admin', {
        admin: true, moviesPanel: false, commentsPanel: true, movies: null, reviews,
      });
    } catch (err) {
      res.status(500).render('error', { message: err, admin: true });
    }
  } else {
    res.status(500).render('error', { message: 'No authorization', admin: true });
  }
});

filtersRouter.get('/admin_search_movies', async (req, res) => {
  if (GetUserClassFromToken(req.cookies.token) === 2) {
    const chunk = {
      searchtitle: req.query.searchtitle,
      searchgenre: req.query.searchgenre,
      minrelease: req.query.minrelease,
      maxrelease: req.query.maxrelease,
    };
    if (chunk.searchtitle === '') {
      chunk.searchtitle = null;
    }
    if (chunk.searchgenre === '') {
      chunk.searchgenre = null;
    }
    if (chunk.minrelease === '') {
      chunk.minrelease = null;
    }
    if (chunk.maxrelease === '') {
      chunk.maxrelease = null;
    }
    try {
      const movies = await selects.getMoviesWithFilter(chunk);
      res.status(200).render('admin', {
        admin: true, moviesPanel: true, commentsPanel: false, movies, reviews: null,
      });
    } catch (err) {
      res.status(500).render('error', { message: err, admin: true });
    }
  } else {
    res.status(500).render('error', { message: 'No authorization', admin: true });
  }
});

filtersRouter.get('/search_user', async (req, res) => {
  if (GetUserClassFromToken(req.cookies.token) === 2) {
    let name = req.query.searchname;
    let userclass = req.query.searchclass;
    if (name === '') {
      name = null;
    }
    if (userclass === '-1') {
      userclass = null;
    }
    try {
      const users = await selects.getUsersWithFilter(name, userclass);
      res.status(200).render('users', { users, admin: true });
    } catch (err) {
      res.status(500).render('error', { message: err, admin: true });
    }
  } else {
    res.status(500).render('error', { message: 'No authorization', admin: true });
  }
});

filtersRouter.post('/search_movies', async (request, response) => {
  const chunk = {
    searchtitle: request.fields.searchtitle,
    searchgenre: request.fields.searchgenre,
    minrelease: request.fields.minrelease,
    maxrelease: request.fields.maxrelease,
  };

  if (chunk.searchtitle === '') {
    chunk.searchtitle = null;
  }

  if (chunk.searchgenre === '') {
    chunk.searchgenre = null;
  }

  if (chunk.minrelease === '') {
    chunk.minrelease = null;
  }

  if (chunk.maxrelease === '') {
    chunk.maxrelease = null;
  }
  const list = await selects.getMoviesWithFilter(chunk);
  const user = GetUsernameFromToken(request.cookies.token);
  const userclass = GetUserClassFromToken(request.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
  }
  if (user === '') {
    response.status(200).render('films', {
      movies: list, loggedin: false, user, admin,
    });
  } else {
    response.status(200).render('films', {
      movies: list, loggedin: true, user, admin,
    });
  }
});

export default filtersRouter;
