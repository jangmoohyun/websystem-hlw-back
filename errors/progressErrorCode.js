export const ProgressErrorCode = {
    NOT_FOUND: {
        code: 'PROGRESS_NOT_FOUND',
        status: 404,
        message: '세이브 데이터를 찾을 수 없습니다.',
    },
    INVALID_SLOT : {
        code: 'INVALID_SLOT',
        status: 400,
        message: '슬롯 번호는 1~5 사이여야 합니다.',
    }
};
