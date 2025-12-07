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
router.get('/google', (req, res, next) => {
    console.log('🔵 Google OAuth 요청 받음:', req.url);
    console.log('🔵 환경변수 확인:', {
        hasClientID: !!process.env.GOOGLE_CLIENT_ID,
        hasClientSecret: !!process.env.GOOGLE_CLIENT_SECRET,
        callbackURL: process.env.GOOGLE_CALLBACK_URL
    });
    passport.authenticate('google', { scope: ['profile', 'email'] })(req, res, next);
}, (err, req, res, next) => {
    if (err) {
        console.error('❌ Google OAuth 인증 에러:', err);
        return res.status(500).json({ 
            success: false, 
            message: 'Google OAuth 인증 실패',
            error: err.message 
        });
    }
    next();
});

router.get('/google/callback', 
    (req, res, next) => {
        console.log('🔵 Google OAuth 콜백 받음:', req.url);
        passport.authenticate('google', { session: false, failureRedirect: '/login' })(req, res, next);
    },
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