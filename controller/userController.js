import * as userService from '../service/userService.js';
import { generateAccessToken, generateRefreshToken, verifyRefreshToken, decodeToken } from '../utils/tokenUtils.js';
import db from '../models/index.js';

const { BlacklistedToken } = db;

// ID로 유저 조회
export const getUser = async (req, res) => {
    const user = await userService.findUserById(req.params.id);
    res.json({ success: true, data: user });
};

// 유저 생성
export const createUser = async (req, res) => {
    const newUser = await userService.createUser(req.body);
    res.status(201).json({ success: true, data: newUser });
};

// 내 프로필 조회
export const getMyProfile = async (req, res) => {
    // authMiddleware 에서 req.user = { id: ... } 형태로 넣어준다고 가정
    const userId = req.user.id;
    const profile = await userService.getProfile(userId);
    res.json({ success: true, data: profile });
};

// 내 프로필 수정
export const updateMyProfile = async (req, res) => {
    const userId = req.user.id;
    const updated = await userService.updateProfile(userId, req.body);
    res.json({ success: true, data: updated });
};

// 일반 로그인
export const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: '이메일과 비밀번호를 입력해주세요.'
            });
        }

        const user = await userService.login({ email, password });

        // 액세스 토큰 및 리프레시 토큰 생성
        const accessToken = generateAccessToken(user.id);
        const refreshToken = generateRefreshToken(user.id);

        // 리프레시 토큰을 DB에 저장
        await userService.saveRefreshToken(user.id, refreshToken);

        res.json({
            success: true,
            message: '로그인 성공',
            data: {
                user: {
                    id: user.id,
                    email: user.email,
                    nickname: user.nickname,
                },
                accessToken: accessToken,
                refreshToken: refreshToken
            }
        });
    } catch (error) {
        // CustomError는 errorHandler에서 처리되지만, 여기서도 처리 가능
        throw error;
    }
};

// 구글 로그인 시작
export const googleLogin = async (req, res, next) => {
    // Passport가 자동으로 처리
    next();
};

// 구글 로그인 콜백 처리 및 JWT 토큰 발급
export const googleCallback = async (req, res) => {
    try {
        const user = req.user; // passport가 req.user에 사용자 정보를 넣어줌
        
        console.log('구글 로그인 콜백 - req.user:', user);
        
        if (!user) {
            console.error('구글 로그인 콜백 - user가 없습니다');
            const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:5173';
            return res.redirect(`${frontendUrl}?error=login_failed`);
        }

        // 액세스 토큰 및 리프레시 토큰 생성
        const accessToken = generateAccessToken(user.id);
        const refreshToken = generateRefreshToken(user.id);

        console.log('구글 로그인 콜백 - 토큰 생성 완료, userId:', user.id);

        // 리프레시 토큰을 DB에 저장
        await userService.saveRefreshToken(user.id, refreshToken);

        // 프론트엔드로 리다이렉트하면서 토큰을 쿼리 파라미터로 전달
        const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:5173';
        // URL 인코딩 처리
        const redirectUrl = `${frontendUrl}?accessToken=${encodeURIComponent(accessToken)}&refreshToken=${encodeURIComponent(refreshToken)}`;
        console.log('구글 로그인 콜백 - 리다이렉트 URL:', redirectUrl.replace(/accessToken=[^&]+&refreshToken=[^&]+/, 'accessToken=***&refreshToken=***'));
        res.redirect(redirectUrl);
    } catch (error) {
        console.error('구글 로그인 콜백 에러:', error);
        const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:5173';
        res.redirect(`${frontendUrl}?error=server_error`);
    }
};

// 토큰 갱신
export const refreshToken = async (req, res) => {
    try {
        const { refreshToken: token } = req.body;

        if (!token) {
            return res.status(400).json({
                success: false,
                message: '리프레시 토큰이 필요합니다.'
            });
        }

        // 리프레시 토큰 검증
        const decoded = verifyRefreshToken(token);
        if (!decoded || decoded.type !== 'refresh') {
            return res.status(401).json({
                success: false,
                message: '유효하지 않은 리프레시 토큰입니다.'
            });
        }

        // DB에서 리프레시 토큰 확인
        const user = await userService.verifyRefreshTokenAndGetUser(token);
        
        // 새 액세스 토큰 생성
        const newAccessToken = generateAccessToken(user.id);

        res.json({
            success: true,
            message: '토큰 갱신 성공',
            data: {
                accessToken: newAccessToken
            }
        });
    } catch (error) {
        throw error;
    }
};

// 로그아웃
export const logout = async (req, res) => {
    try {
        const userId = req.user?.id;
        const authHeader = req.headers.authorization;
        const accessToken = authHeader?.replace('Bearer ', '');

        if (userId) {
            // 리프레시 토큰 삭제
            await userService.removeRefreshToken(userId);
        }

        // 액세스 토큰을 블랙리스트에 추가
        if (accessToken) {
            const decoded = decodeToken(accessToken);
            if (decoded && decoded.exp) {
                const expiresAt = new Date(decoded.exp * 1000);
                await BlacklistedToken.create({
                    token: accessToken,
                    expiresAt: expiresAt
                });
            }
        }

        res.json({
            success: true,
            message: '로그아웃 성공'
        });
    } catch (error) {
        throw error;
    }
};

// 유저 페이지 정보 조회
export const getUserPage = async (req, res) => {
    const userId = req.user.id; // 인증된 사용자 ID
    const pageInfo = await userService.getUserPageInfo(userId);
    res.json({ success: true, data: pageInfo });
};