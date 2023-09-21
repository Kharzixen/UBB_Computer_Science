import express from 'express';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import * as selects from '../db/selects.js';
import * as inserts from '../db/insert.js';

const secret = '1c28d07215544bd1b24faccad6c14a04';

export const logedUsers = [];

// autentification functions and router

export function GetUsernameFromToken(token) {
  let username = '';
  if (token) {
    jwt.verify(token, secret,  (err, payload) => {
      if (payload) {
        username = payload.username;
      } else {
        console.log(`GetUsernameFromToken error: ${err}`);
      }
    });
  }
  return username;
}

export function GetUserIDFromToken(token) {
  let id = '';
  if (token) {
    jwt.verify(token, secret,  (err, payload) => {
      if (payload) {
        id = payload.id;
      } else {
        console.log(`GetUserIDFromToken error: ${err}`);
      }
    });
  }
  return id;
}

export function GetUserClassFromToken(token) {
  let userclass = '';
  if (token) {
    jwt.verify(token, secret,  (err, payload) => {
      if (payload) {
        userclass = payload.userclass;
      } else {
        console.log(`GetUserClassFromToken error: ${err}`);
      }
    });
  }
  return userclass;
}

// logout all user-tokens
export function LogoutUser(username) {
  let i = logedUsers.length;
  i -= 1;
  while (i >= 0) {
    if (logedUsers[i] === username) {
      logedUsers.splice(i, 1);
    }
    i -= 1;
  }
}

const authRouter = express.Router();

authRouter.post('/registeruser', async (req, res) => {
  const salt = await bcrypt.genSalt(10);
  const formData = {
    username: req.fields.username,
    passwd: req.fields.passwd,
    confpasswd: req.fields.confpasswd,
  };
  const userclass = GetUserClassFromToken(req.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
  }
  if (formData.username === '') {
    res.status(500).render('register', { msg: 'Please enter a valid username.', admin });
    return;
  }

  if (formData.passwd.length < 6) {
    res.status(500).render('register', { msg: 'Please enter a password with minimum length of 6.', admin });
    return;
  }

  const userWithName = await selects.getUsersWithName(formData.username);

  if (userWithName.length !== 0) {
    console.log(`Registration error: This username = ${formData.username} is taken!`);
    res.status(500).render('register', { msg: 'This username is taken!', admin });
    return;
  }

  if (formData.confpasswd !== formData.passwd) {
    res.status(500).render('register', { msg: 'Passwords does not match!', admin });
  } else {
    const hash = await bcrypt.hash(formData.passwd, salt);
    const encryptData = {
      username: formData.username,
      cryptedpasswd: hash,
      class: 1,
    };
    try {
      await inserts.insertUser(encryptData);
    } catch (err) {
      res.status(500).render('error', { message: 'Insertation error...', admin });
    }
    res.status(200).render('register', { msg: 'Successful registration :)', admin });
  }
});

authRouter.post('/loginuser', async (req, res) => {
  const { username } = req.fields;
  const { passwd } = req.fields;
  const user = await selects.getUsersWithName(username);
  if (!user[0]) {
    res.status(500).render('login', { msg: 'Incorrect username or password', admin: false });
    return;
  }
  const id = user[0].UserID;
  const userclass = user[0].Class;
  const validPasswd = await bcrypt.compare(passwd, user[0].Password);
  if (validPasswd) {
    const token = jwt.sign({ id, username, userclass }, secret);
    logedUsers.push(username);
    res.cookie('token', token, { httpOnly: true }).status(200).redirect('/');
  } else {
    res.status(500).render('login', { msg: 'Incorrect username or password', admin: false });
  }
});

authRouter.post('/logout', (req, res) => {
  if (req.cookies.token) {
    const username = GetUsernameFromToken(req.cookies.token);
    if (username) {
      logedUsers.splice(logedUsers.indexOf(username), 1);
      res.status(200).clearCookie('token').redirect('/');
    }
  } else {
    res.redirect('/');
  }
});

export const AuthRouter = authRouter;
export const Secret = secret;
