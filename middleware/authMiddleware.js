import passport from 'passport';

// JWT 인증 미들웨어
export const authMiddleware = passport.authenticate('jwt', { session: false });