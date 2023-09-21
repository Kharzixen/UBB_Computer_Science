import express from 'express';
import favicon from 'serve-favicon';
import { join } from 'path';
import morgan from 'morgan';
import cookieParser from 'cookie-parser';
import { existsSync, mkdirSync } from 'fs';
import eformidable from 'express-formidable';
import generalRouter from './routs/generalRequests.js';
import reviewRouter from './routs/reviews.js';
import uploadRouter from './routs/uploads.js';
import DetailsRouter from './routs/details.js';
import  { endpointNotFound, VerifyToken } from './middleware/errorMiddleware.js';
import { AuthRouter } from './auth/auth.js';
import administrationRouter from './administration/administration.js';
import filtersRouter from './routs/filters.js';

const app = express();

const uploadDir = join(join(process.cwd(), 'static'), 'uploadDir');

if (!existsSync(uploadDir)) {
  mkdirSync(uploadDir);
}

app.use(eformidable({ uploadDir }));

app.use(express.static(join(process.cwd(), 'static')));

app.set('view engine', 'ejs');
app.set('views', join(process.cwd(), 'views'));

app.use(morgan('tiny'));

app.use(cookieParser());

app.use(VerifyToken);

app.use(favicon(join(process.cwd(), 'static', 'favicon.ico')));

app.use(generalRouter);

app.use(AuthRouter);

app.use(administrationRouter);

app.use(uploadRouter);

app.use(reviewRouter);

app.use(filtersRouter);

app.use(DetailsRouter);

app.use(endpointNotFound);

app.listen(3000, () => { console.log('Listening on port: 3000'); });
