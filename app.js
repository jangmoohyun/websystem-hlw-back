import express from 'express';
import cookieParser from 'cookie-parser';
import logger from 'morgan';
import passport from 'passport';
import cors from 'cors';

import indexRouter from './routes/index.js';
import usersRouter from './routes/userRouter.js';
import storyRouter from './routes/storyRouter.js';
import progressRouter from './routes/progressRouter.js';
import heroineRouter from './routes/heroineRouter.js';
import { notFound } from './middleware/notFound.js';
import { errorHandler } from './middleware/errorHandler.js';
import { checkTokenBlacklist } from './middleware/tokenBlacklistMiddleware.js';
import passportConfig from './config/passport.js';

const app = express();

// Passport 초기화
passportConfig(passport);
app.use(passport.initialize());

// CORS 설정 (프론트엔드 연동을 위해)
app.use(
    cors({
        origin: process.env.FRONTEND_URL || 'http://localhost:5173', // 프론트엔드 주소 (Vite 기본 포트)
        credentials: true, // 쿠키/인증 정보 포함 허용
    })
);

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// 토큰 블랙리스트 확인 (인증 미들웨어 전에 실행)
app.use(checkTokenBlacklist);

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/stories', storyRouter);
app.use('/progress', progressRouter);
app.use('/heroines', heroineRouter);

app.use(notFound);

app.use(errorHandler);

export default app;