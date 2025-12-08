import db from "../models/index.js";
import { CustomError } from "../utils/customError.js";
import { UserErrorCode } from "../errors/userErrorCode.js";
import bcrypt from "bcrypt";

const { User, Progress, Story, HeroineLike, Heroine } = db;

// 공통: id로 유저 조회 (비밀번호 제외)
export const findUserById = async (id) => {
  const user = await User.findByPk(id, {
    attributes: ["id", "email", "nickname", "createdAt", "updatedAt"],
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

  // 비밀번호 해싱
  let hashedPassword = null;
  if (password) {
    hashedPassword = await bcrypt.hash(password, 10);
  }

  const user = await User.create({ email, password: hashedPassword, nickname });
  // 비밀번호는 응답에 포함하지 않음
  const plain = user.get({ plain: true });
  delete plain.password;
  return plain;
};

// 일반 로그인 (이메일/비밀번호)
export const login = async ({ email, password }) => {
  // 이메일로 사용자 찾기 (비밀번호 포함)
  const user = await User.findOne({
    where: { email },
    attributes: ["id", "email", "password", "nickname", "provider"],
  });

  if (!user) {
    throw CustomError.from(UserErrorCode.INVALID_CREDENTIALS);
  }

  // SNS 로그인 사용자는 일반 로그인 불가
  if (user.provider && user.provider !== "local") {
    throw CustomError.from(UserErrorCode.INVALID_CREDENTIALS);
  }

  // 비밀번호가 없는 경우 (SNS만 가입한 경우)
  if (!user.password) {
    throw CustomError.from(UserErrorCode.INVALID_CREDENTIALS);
  }

  // 비밀번호 검증
  const isPasswordValid = await bcrypt.compare(password, user.password);
  if (!isPasswordValid) {
    throw CustomError.from(UserErrorCode.INVALID_CREDENTIALS);
  }

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

  await user.save();

  const plain = user.get({ plain: true });
  delete plain.password;
  return plain;
};

// 리프레시 토큰 저장
export const saveRefreshToken = async (userId, refreshToken) => {
  const user = await User.findByPk(userId);
  if (!user) throw CustomError.from(UserErrorCode.NOT_FOUND);

  user.refreshToken = refreshToken;
  await user.save();
};

// 리프레시 토큰 검증 및 사용자 조회
export const verifyRefreshTokenAndGetUser = async (refreshToken) => {
  const user = await User.findOne({
    where: { refreshToken },
    attributes: ["id", "email", "nickname", "refreshToken"],
  });

  if (!user) {
    throw CustomError.from(UserErrorCode.INVALID_CREDENTIALS);
  }

  return user;
};

// 리프레시 토큰 삭제 (로그아웃)
export const removeRefreshToken = async (userId) => {
  const user = await User.findByPk(userId);
  if (user) {
    user.refreshToken = null;
    await user.save();
  }
};

// 유저 페이지 정보 조회 (닉네임, progress, heroine_like)
export const getUserPageInfo = async (userId) => {
  // 유저 정보 조회 (닉네임 포함)
  const user = await User.findByPk(userId, {
    attributes: ["id", "nickname", "email", "createdAt"],
  });

  if (!user) {
    throw CustomError.from(UserErrorCode.NOT_FOUND);
  }

  // progress에서 userId로 storyId 가져오기
  const progresses = await Progress.findAll({
    where: { userId },
    attributes: [
      "id",
      "slot",
      "lineIndex",
      "storyId",
      "createdAt",
      "updatedAt",
    ],
    include: [
      {
        model: Story,
        as: "story",
        attributes: ["id", "title", "content", "image"],
      },
    ],
    order: [["slot", "ASC"]],
  });

  // heroine_like에서 userId로 각 히로인에 대한 호감도 가져오기
  // progress를 통해 heroine_like에 접근해야 함
  const heroineLikes = await HeroineLike.findAll({
    include: [
      {
        model: Progress,
        as: "progress",
        where: { userId },
        attributes: [],
      },
      {
        model: Heroine,
        as: "heroine",
        attributes: ["id", "name", "language"],
      },
    ],
    attributes: ["id", "likeValue", "heroineId"],
  });

  // 히로인별로 호감도 그룹화
  const heroineLikeMap = {};
  heroineLikes.forEach((like) => {
    const heroineId = like.heroineId;
    if (!heroineLikeMap[heroineId]) {
      heroineLikeMap[heroineId] = {
        heroine: like.heroine,
        likes: [],
      };
    }
    heroineLikeMap[heroineId].likes.push({
      id: like.id,
      likeValue: like.likeValue,
    });
  });

  return {
    user: {
      id: user.id,
      nickname: user.nickname,
      email: user.email,
      createdAt: user.createdAt,
    },
    progresses: progresses.map((p) => ({
      id: p.id,
      slot: p.slot,
      lineIndex: p.lineIndex,
      story: p.story
        ? {
            id: p.story.id,
            title: p.story.title,
            content: p.story.content,
            image: p.story.image,
          }
        : null,
      createdAt: p.createdAt,
      updatedAt: p.updatedAt,
    })),
    heroineLikes: Object.values(heroineLikeMap).map((item) => ({
      heroine: item.heroine,
      likes: item.likes,
    })),
  };
};
