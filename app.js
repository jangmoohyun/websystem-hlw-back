import express from 'express';
import path, { dirname, join } from 'path';
import cookieParser from 'cookie-parser';
import logger from 'morgan';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

import indexRouter from './routes/index.js';
import usersRouter from './routes/userRouter.js';
import { notFound } from './middleware/notFound.js';
import { errorHandler } from './middleware/errorHandler.js';

import { connectDB } from './db/index.js';
import db from './models/index.js';

const app = express();

// DB 연결 & 모델 sync
(async () => {
    try {
        await db.sequelize.sync(); // 실제 테이블 생성/동기화
        console.log('✅ Sequelize 모델 sync 완료');
    } catch (err) {
        console.error('❌ DB 초기화 중 에러:', err);
    }
})();

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

app.use(notFound);

app.use(errorHandler);

export default app;