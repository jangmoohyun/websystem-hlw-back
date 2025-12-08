
import express from 'express';
import cookieParser from 'cookie-parser';
import logger from 'morgan';
import passport from 'passport';
import cors from 'cors';

import indexRouter from './routes/index.js';
import usersRouter from './routes/userRouter.js';
import storyRouter from './routes/storyRouter.js';
import problemRouter from "./routes/problemRouter.js";
import progressRouter from './routes/progressRouter.js';
import heroineRouter from './routes/heroineRouter.js';
import choiceRouter from "./routes/choiceRouter.js";
import { notFound } from './middleware/notFound.js';
import { errorHandler } from './middleware/errorHandler.js';
import { checkTokenBlacklist } from './middleware/tokenBlacklistMiddleware.js';
import passportConfig from './config/passport.js';


const app = express();

// Passport 초기화
passportConfig(passport);
app.use(passport.initialize());

// CORS 설정 (프론트엔드 연동을 위해)
const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:5173';
console.log('🌐 CORS 설정:', { frontendUrl });
app.use(
    cors({
        origin: frontendUrl, // 프론트엔드 주소 (Vite 기본 포트)
        credentials: true, // 쿠키/인증 정보 포함 허용
    })
);

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// 요청 로깅 미들웨어 (디버깅용) - 라우팅 전에 실행
app.use((req, res, next) => {
    console.log(`📥 요청 받음: ${req.method} ${req.originalUrl}`);
    console.log(`📥 요청 헤더:`, {
        origin: req.headers.origin,
        referer: req.headers.referer,
        host: req.headers.host
    });
    next();
});

// 토큰 블랙리스트 확인 (인증 미들웨어 전에 실행)
app.use(checkTokenBlacklist);

// 라우팅 설정
console.log('🔧 라우팅 설정 시작');
app.use('/', indexRouter);
app.use('/users', usersRouter);
console.log('🔧 /users 라우터 등록 완료');
app.use('/stories', storyRouter);
app.use('/progress', progressRouter);
app.use('/heroines', heroineRouter);
app.use("/problems", problemRouter);
app.use("/choices", choiceRouter);


app.use(notFound);

app.use(errorHandler);

export default app;
