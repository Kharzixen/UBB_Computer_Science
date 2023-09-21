import express from 'express';
import * as inserts from '../db/insert.js';
import * as deletes from '../db/delete.js';
import { GetUserClassFromToken } from '../auth/auth.js';

// functions for data validation:

function validTitle(title) {
  return title.match(/^[A-Z][A-Za-z0-9', .-]*/);
}

function isDate(s) {
  return !Number.isNaN(Date.parse(s));
}

function validGenres(genres) {
  return genres.match(/^\s*[a-z0-9-]+(?:\s*[a-z0-9-]+)*\s*$/);
}

const uploadRouter = express.Router();

// acces router
uploadRouter.get(['/upload', '/upload.html'], (req, res) => {
  const userclass = GetUserClassFromToken(req.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
    res.status(200).render('upload', { admin });
  } else {
    res.status(500).render('error', { message: 'Unathorized!', admin });
  }
});

// upload a movie with upload form, with user (admin) validation
uploadRouter.post('/upload_movie', (request, response) => {
  const userclass = GetUserClassFromToken(request.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
    const coverPhoto = request.files.cover;
    const chunk = {
      title: request.fields.title,
      release: request.fields.release,
      genres: request.fields.genres,
      cover: coverPhoto.path,
      description: request.fields.descr,
    };
    // validate the submited data
    if (!validTitle(chunk.title)) {
      response.status(422).render('error', { message: 'Movie can\'t be uploaded , beacuse the given title is incorrect .', admin });
    } else if (!isDate(chunk.release)) {
      response.status(422).render('error', { message: 'Movie can\'t be uploaded , beacuse the given date is incorrect .', admin });
    } else if (!validGenres(chunk.genres)) {
      response.status(422).render('error', { message: 'Movie can\'t be uploaded , beacuse the genres field is incorrect (please fo llow this pattern: "genre1 genre2 ...") .', admin });
    } else {
      inserts.insertMovie(request, (err) => {
        if (err) {
          console.log(`Upload Error + ${err}`);
          response.render('error', { message: err, admin });
        } else {
          response.status(200).redirect('/');
        }
      });
    }
  } else {
    response.status(500).render('Error', { message: 'Unauthorized', admin });
  }
});

// movie deletion with user validation
uploadRouter.post('/delete_movie', (req, res) => {
  const userclass = GetUserClassFromToken(req.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
    try {
      deletes.removeMovieByID(req.fields.id);
      res.status(200).redirect('/');
    } catch (err) {
      res.status(500).render('error', { message: err, admin: true });
    }
  } else {
    res.status(500).render('Error', { message: 'Unauthorized', admin });
  }
});

export default uploadRouter;
