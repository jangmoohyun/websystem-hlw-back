import passport from 'passport';
import { Strategy as GoogleStrategy } from 'passport-google-oauth20';
import { Strategy as JwtStrategy, ExtractJwt } from 'passport-jwt';
import db from '../models/index.js';
import { verifyAccessToken } from '../utils/tokenUtils.js';

const User = db.User;

// JWT 전략 설정 (액세스 토큰만 검증)
const jwtOptions = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
  secretOrKey: process.env.JWT_SECRET || 'your_jwt_secret',
};

const jwtVerify = async (payload, done) => {
  try {
    // 액세스 토큰만 허용
    if (payload.type !== 'access') {
      return done(null, false);
    }

    // payload에 담긴 사용자 ID로 사용자를 찾습니다.
    const user = await User.findOne({ where: { id: payload.id } });
    if (user) {
      return done(null, user); // 사용자가 있으면 인증 성공
    }
    return done(null, false); // 사용자가 없으면 인증 실패
  } catch (error) {
    return done(error, false);
  }
};

// Google Oauth 전략 설정
const googleOptions = {
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: process.env.GOOGLE_CALLBACK_URL || 'http://localhost:3000/users/google/callback',
};

// 환경변수 확인 로그 (디버깅용)
console.log('Google OAuth 설정:', {
    hasClientID: !!process.env.GOOGLE_CLIENT_ID,
    hasClientSecret: !!process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: process.env.GOOGLE_CALLBACK_URL || 'http://localhost:3000/users/google/callback',
});

const googleVerify = async (accessToken, refreshToken, profile, done) => {
    console.log('Google profile:', profile);
    try {
        let user = await User.findOne({ where: { snsId: profile.id, provider: 'google' } });

        if (user) {
            return done(null, user); // 기존 사용자가 있으면 로그인 성공
        } else {
            // 기존 사용자가 없다면 새로 생성합니다.
            const newUser = await User.create({
                email: profile.emails[0].value,
                nickname: profile.displayName,
                snsId: profile.id,
                provider: 'google',
            });
            return done(null, newUser); // 새 사용자 생성 후 로그인 성공
        }
    } catch (error) {
        console.error(error);
        return done(error);
    }
};


export default (passport) => {
    try {
        if (!process.env.GOOGLE_CLIENT_ID || !process.env.GOOGLE_CLIENT_SECRET) {
            console.error('❌ Google OAuth 환경변수가 설정되지 않았습니다!');
            console.error('GOOGLE_CLIENT_ID:', !!process.env.GOOGLE_CLIENT_ID);
            console.error('GOOGLE_CLIENT_SECRET:', !!process.env.GOOGLE_CLIENT_SECRET);
        } else {
            console.log('✅ Google OAuth 환경변수 확인 완료');
        }
        passport.use(new GoogleStrategy(googleOptions, googleVerify));
        passport.use(new JwtStrategy(jwtOptions, jwtVerify));
    } catch (error) {
        console.error('❌ Passport 전략 설정 실패:', error);
        throw error;
    }
};