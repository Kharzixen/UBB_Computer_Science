import jwt from 'jsonwebtoken';
import {
  Secret, GetUserClassFromToken,
  logedUsers,
} from '../auth/auth.js';

// last middleware
export function endpointNotFound(req, res) {
  const userclass = GetUserClassFromToken(req.cookies.token);
  let admin = false;
  if (userclass === 2) {
    admin = true;
  }
  res.status(404).render('error', { message: `Endpoint not found ${req}`, admin  });
}

// token verification
export function VerifyToken(req, res, next) {
  if (req.cookies.token) {
    const userclass = GetUserClassFromToken(req.cookies.token);
    let admin = false;
    if (userclass === 2) {
      admin = true;
    }
    jwt.verify(req.cookies.token, Secret,  (err, payload) => {
      if (payload) {
        if (logedUsers.includes(payload.username)) {
          console.log(`Loged in user: ${payload.username}`);
          next();
        } else {
          res.status(500).clearCookie('token').redirect('/');
        }
      } else {
        res.status(401).render('error', { message: err, admin });
      }
    });
  } else {
    next();
  }
}
