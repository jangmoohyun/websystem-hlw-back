export const UserErrorCode = {
    NOT_FOUND: {
        code: 'USER_NOT_FOUND',
        status: 404,
        message: '사용자를 찾을 수 없습니다.',
    },
    DUPLICATE_EMAIL: {
        code: 'USER_DUPLICATE_EMAIL',
        status: 409,
        message: '이미 사용 중인 이메일입니다.',
    },
    INVALID_CREDENTIALS: {
        code: 'USER_INVALID_CREDENTIALS',
        status: 401,
        message: '이메일 또는 비밀번호가 올바르지 않습니다.',
    },
    DUPLICATE_NICKNAME: {
        code: 'USER_DUPLICATE_NICKNAME',
        status: 409,
        message: '이미 사용 중인 닉네임입니다.',
    },
    FORBIDDEN: {
        code: 'USER_FORBIDDEN',
        status: 403,
        message: '해당 작업을 수행할 권한이 없습니다.',
    },
};