import express from 'express';
import * as selects from '../db/selects.js';
import * as inserts from '../db/insert.js';
import * as updates from '../db/updates.js';
import { GetUsernameFromToken, GetUserClassFromToken } from '../auth/auth.js';

const reviewRouter = express.Router();

// rating validation
async function RatingIsValid(chunk) {
  let validMovie = false;
  let validUser = false;
  let validID = true;
  if (Number.isNaN(chunk.id) || Number.isNaN(chunk.rating)) {
    validID = false;
  }

  try {
    const movies = await selects.findMovieIDsNew();
    movies.forEach((movie) => {
      if (`${movie.MovieID}` === `${chunk.id}`) {
        validMovie = true;
      }
    });
    const users = await selects.findUsersNew();
    users.forEach((user) => {
      if (user.Username === chunk.user) {
        validUser = true;
      }
    });
  } catch (err) {
    console.log(`Rating validation error: ${err}`);
  }
  if (validUser && validMovie && validID) {
    return true;
  }
  return false;
}

// details site review form submit with user rights validation
reviewRouter.post('/submitDetailsReview', async (request, response) => {
  if (GetUsernameFromToken(request.cookies.token) !== '') {
    const chunk = {
      id: request.fields.selectedmovie,
      user: GetUsernameFromToken(request.cookies.token),
      rating: request.fields.rating,
      review: request.fields.rev,
      status: 1,
      isadmin: false,
    };
    if (GetUserClassFromToken(request.cookies.token) === 2) {
      chunk.isadmin = true;
    }
    let id = null;
    if (RatingIsValid(chunk)) {
      try {
        id = await inserts.insertReviewNew(chunk);
        chunk.id = id.insertId;
        response.status(200);
        response.setHeader('Content-Type', 'application/json');
        response.end(JSON.stringify(chunk));
      } catch (err) {
        console.log(`Review Error: ${err}`);
        const errorchunk = {
          error: `${err}`,
        };
        response.status(500);
        response.setHeader('Content-Type', 'application/json');
        response.end(JSON.stringify(errorchunk));
      }
    } else {
      console.log('Incorrect data passed to server');
      const errorchunk = {
        error: 'Incorrect data passed to server',
      };
      response.status(500);
      response.setHeader('Content-Type', 'application/json');
      response.end(JSON.stringify(errorchunk));
    }
  } else {
    console.log('Unauthorised');
    const errorchunk = {
      error: 'Unauthorized',
    };
    response.status(500);
    response.setHeader('Content-Type', 'application/json');
    response.end(JSON.stringify(errorchunk));
  }
});

// admin function: approve a comment
reviewRouter.post('/approve_comment', async (req, res) => {
  const revid = req.fields.id;
  if (GetUserClassFromToken(req.cookies.token) === 2) {
    await updates.approveComment(revid, GetUsernameFromToken(req.cookies.token));
    res.status(200);
    res.setHeader('Content-Type', 'application/json');
    const retmess = {
      msg: `Approved by: ${GetUsernameFromToken(req.cookies.token)}`,
    };
    res.end(JSON.stringify(retmess));
  } else {
    console.log('Approve error: Unatuhorised');
    const errorchunk = {
      error: 'Unauthorised',
    };
    res.status(401);
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(errorchunk));
  }
});

// admin function: refuse a comment
reviewRouter.post('/refuse_comment', async (req, res) => {
  const revid = req.fields.id;
  if (GetUserClassFromToken(req.cookies.token) === 2) {
    await updates.refuseComment(revid, GetUsernameFromToken(req.cookies.token));
    res.status(200);
    res.setHeader('Content-Type', 'application/json');
    const retmess = {
      msg: `Refused by: ${GetUsernameFromToken(req.cookies.token)}`,
    };
    res.end(JSON.stringify(retmess));
  } else {
    console.log('Refuse error: Unatuhorised');
    const errorchunk = {
      error: 'Unauthorised',
    };
    res.status(500);
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(errorchunk));
  }
});

export default reviewRouter;
