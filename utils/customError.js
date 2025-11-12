export class CustomError extends Error {
    constructor({ message, status = 500, code = 'INTERNAL_ERROR',cause } = {}) {
        super(message, { cause });
        this.name = 'CustomError';
        this.status = status;
        this.code = code;
    }

    static from(errorCode, overrides = {}) {
        const { message, status, code } = errorCode;
        return new CustomError({ message, status, code, ...overrides });
    }
}
