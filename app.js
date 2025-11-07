import createError from 'http-errors';
import express from 'express';
import path, { dirname, join } from 'path';
import cookieParser from 'cookie-parser';
import logger from 'morgan';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

import indexRouter from './routes/index.js';
import usersRouter from './routes/userRouter.js';

const app = express();

// view engine setup
app.set('views', join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

// catch 404 and forward to error handler
app.use((req, res, next) => {
    next(createError(404));
});

// error handler
const errorHandler = (err, req, res) => {
    res.locals.message = err?.message ?? 'Internal Server Error';
    res.locals.error = req.app.get('env') === 'development' ? err : {};
    res.status(err?.status ?? 500);
    res.render('error'); // 뷰 안 쓰면 아래 JSON 버전 사용
};

app.use(errorHandler);

export default app;