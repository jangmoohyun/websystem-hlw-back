import db from '../models/index.js';
import { CustomError } from '../utils/customError.js';
import { UserErrorCode } from '../errors/userErrorCode.js';

const { User } = db;

// 공통: id로 유저 조회 (비밀번호 제외)
export const findUserById = async (id) => {
    const user = await User.findByPk(id, {
        attributes: ['id', 'email', 'nickname', 'createdAt', 'updatedAt'],
    });

    if (!user) throw CustomError.from(UserErrorCode.NOT_FOUND);
    return user;
};

// 회원 가입
export const createUser = async ({ email, password, nickname }) => {
    // 이메일 중복 체크
    const existsEmail = await User.findOne({ where: { email } });
    if (existsEmail) throw CustomError.from(UserErrorCode.DUPLICATE_EMAIL);

    // 닉네임 중복 체크
    if (nickname) {
        const existsNick = await User.findOne({ where: { nickname } });
        if (existsNick) throw CustomError.from(UserErrorCode.DUPLICATE_NICKNAME);
    }

    const user = await User.create({ email, password, nickname });
    // 비밀번호는 응답에 포함하지 않음
    const plain = user.get({ plain: true });
    delete plain.password;
    return plain;
};

// 내 프로필 조회 (id 기준)
export const getProfile = async (userId) => {
    return await findUserById(userId);
};

// 내 프로필 수정
export const updateProfile = async (userId, payload) => {
    const user = await User.findByPk(userId);
    if (!user) throw CustomError.from(UserErrorCode.NOT_FOUND);

    const { nickname, avatarUrl, bio } = payload;

    // 닉네임 변경 시 중복 체크
    if (nickname && nickname !== user.nickname) {
        const existsNick = await User.findOne({ where: { nickname } });
        if (existsNick) throw CustomError.from(UserErrorCode.DUPLICATE_NICKNAME);
    }

    if (nickname !== undefined) user.nickname = nickname;
    if (avatarUrl !== undefined) user.avatarUrl = avatarUrl;
    if (bio !== undefined) user.bio = bio;

    await user.save();

    const plain = user.get({ plain: true });
    delete plain.password;
    return plain;
};