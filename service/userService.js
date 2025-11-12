import { CustomError } from '../utils/CustomError.js';
import { UserErrorCode } from '../errors/UserErrorCode.js';

// 임시 메모리 데이터
const users = [{ id: 1, email: 'test@example.com', name: 'Tester' }];

export const findUserById = async (id) => {
    const user = users.find((u) => u.id === Number(id));
    if (!user) throw CustomError.from(UserErrorCode.NOT_FOUND);
    return user;
};

export const createUser = async (data) => {
    const { email, name } = data;
    if (users.some((u) => u.email === email))
        throw CustomError.from(UserErrorCode.DUPLICATE_EMAIL);

    const newUser = { id: users.length + 1, email, name };
    users.push(newUser);
    return newUser;
};