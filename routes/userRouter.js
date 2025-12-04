import express from 'express';
import passport from 'passport';
import { asyncHandler } from '../middleware/asyncHandler.js';
import * as userController from '../controller/userController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// 일반 로그인
router.post('/login', asyncHandler(userController.login));

// 토큰 갱신
router.post('/refresh', asyncHandler(userController.refreshToken));

// 로그아웃 (인증 필요)
router.post('/logout', authMiddleware, asyncHandler(userController.logout));

// 구글 로그인
router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'] }));
router.get('/google/callback', 
    passport.authenticate('google', { session: false, failureRedirect: '/login' }),
    asyncHandler(userController.googleCallback)
);

// 유저 조회
router.get('/:id', asyncHandler(userController.getUser));

// 유저 생성 (회원가입)
router.post('/', asyncHandler(userController.createUser));

// 프로필 관리 (인증 필요)
router.get('/me', authMiddleware, asyncHandler(userController.getMyProfile));
router.patch('/me', authMiddleware, asyncHandler(userController.updateMyProfile));

// 유저 페이지 정보 조회 (인증 필요)
router.get('/me/page', authMiddleware, asyncHandler(userController.getUserPage));

export default router;