import { CustomError } from '../utils/CustomError.js';

export const notFound = (req, res, next) => {
    next(new CustomError({
        status: 404,
        code: 'NOT_FOUND',
        message: '요청하신 리소스를 찾을 수 없습니다.'
    }));
};