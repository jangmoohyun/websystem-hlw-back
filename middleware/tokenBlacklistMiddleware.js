import db from '../models/index.js';
import { Op } from 'sequelize';

const { BlacklistedToken } = db;

// 토큰 블랙리스트 확인 미들웨어
export const checkTokenBlacklist = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            return next();
        }

        const token = authHeader.replace('Bearer ', '');
        
        // 블랙리스트에 있는 토큰인지 확인
        const blacklisted = await BlacklistedToken.findOne({
            where: { token }
        });

        if (blacklisted) {
            return res.status(401).json({
                success: false,
                message: '토큰이 무효화되었습니다.'
            });
        }

        // 만료된 블랙리스트 항목 정리 (백그라운드 작업)
        await BlacklistedToken.destroy({
            where: {
                expiresAt: {
                    [Op.lt]: new Date()
                }
            }
        });

        next();
    } catch (error) {
        next(error);
    }
};

