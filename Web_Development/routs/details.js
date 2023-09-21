import express from 'express';
import { GetUsernameFromToken, GetUserClassFromToken } from '../auth/auth.js';
import * as selects from '../db/selects.js';
import * as del from '../db/delete.js';

// router about details ie comments, getting more details

const DetailsRouter = express.Router();

DetailsRouter.get('/get_details', async (request, response) => {
  const movieid = request.query.id;
  let movie = null;
  let users = null;
  let reviews = null;
  if (movieid.isNaN) {
    console.log('GetDetails eror: Input data is incorrect');
  } else {
    const userclass = GetUserClassFromToken(request.cookies.token);
    let admin = false;
    if (userclass === 2) {
      admin = true;
    }
    try {
      movie = await selects.getMovieWithIDNew(movieid);
      const thisuser = GetUsernameFromToken(request.cookies.token);
      users = await selects.findUsersNew();
      reviews = await selects.getReviewsNew(movieid);
      response.status(200).render('details', {
        condition: 0, movie, users, user: thisuser, reviews, admin,
      });
    } catch (err) {
      response.status(500).render('error', { message: `${err}`, admin });
    }
  }
});

DetailsRouter.get('/getMoreData', async (req, res) => {
  try {
    const id = req.query.movieID;
    const movie = await selects.getMovieWithIDNew(id);
    res.status(200);
    res.type('json');
    res.end(JSON.stringify(movie));
  } catch (err) {
    console.log(`Get More Data error: ${err}`);
    const chunk = {
      error: `${err}`,
    };
    res.status(500);
    res.type('json');
    res.end(JSON.stringify(chunk));
  }
});

DetailsRouter.get('/adminMovies', async (req, res) => {
  if (GetUserClassFromToken(req.cookies.token) === 2) {
    const movies = await selects.GetAllMovies();
    res.status(200).render('admin', {
      admin: true, moviesPanel: true, commentsPanel: false, movies, reviews: null,
    });
  } else {
    res.status(500).render('error', { message: 'No authorization', admin: false });
  }
});

DetailsRouter.get('/adminComments', async (req, res) => {
  if (GetUserClassFromToken(req.cookies.token) === 2) {
    const reviews = await selects.GetAllReviews();
    res.status(200).render('admin', {
      admin: true, moviesPanel: false, commentsPanel: true, movies: null, reviews,
    });
  } else {
    res.status(500).render('error', { message: 'No authorization', admin: false });
  }
});

DetailsRouter.post('/delete_comment', async (req, res) => {
  const revid = req.fields.id;
  const owner = req.fields.user;
  try {
    // akkor törölhetünk ha a saját komment vagy admin,
    // ezzel ellenorizzuk azt is hogy ervenyes token-e
    if (owner === GetUsernameFromToken(req.cookies.token)
      || GetUserClassFromToken(req.cookies.token) === 2) {
      await del.removeReviewByID(revid);
      res.status(200);
      res.setHeader('Content-Type', 'application/json');
      const retmess = {
        msg: '*message deleted*',
      };
      res.end(JSON.stringify(retmess));
    } else {
      console.log('Review Deletion: Unatuhorised');
      const errorchunk = {
        error: 'Unauthorised',
      };
      res.status(500);
      res.setHeader('Content-Type', 'application/json');
      res.end(JSON.stringify(errorchunk));
    }
  } catch (err) {
    console.log(`Review deletion error: ${err}`);
    const errorchunk = {
      error: err,
    };
    res.status(500);
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(errorchunk));
  }
});

export default DetailsRouter;
