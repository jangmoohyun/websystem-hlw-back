import { CustomError } from '../utils/CustomError.js';

export const errorHandler = (err, req, res, next) => {
    // CustomError가 아니면 안전하게 래핑
    const isKnown = err instanceof CustomError;
    const status = isKnown ? err.status : (err.status || 500);
    const code = isKnown ? err.code : (err.code || 'INTERNAL_ERROR');
    const message = isKnown ? err.message : (err.message || 'Internal Server Error');

    // 운영 환경에서는 details/stack 최소화
    const isDev = req.app.get('env') === 'development';

    const payload = {
        success: false,
        error: {
            code,
            message,
            status,
            path: req.originalUrl,
            method: req.method,
            timestamp: new Date().toISOString(),
        },
    };

    if (isDev) {
        payload.error.details = isKnown ? err.details : undefined;
        payload.error.stack = err.stack;
        if (err.cause) payload.error.cause = String(err.cause);
    }

    res.status(status).json(payload);
};
