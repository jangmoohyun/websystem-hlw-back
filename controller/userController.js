import * as userService from '../service/userService.js';

// ID로 유저 조회
export const getUser = async (req, res) => {
    const user = await userService.findUserById(req.params.id);
    res.json({ success: true, data: user });
};

// 유저 생성
export const createUser = async (req, res) => {
    const newUser = await userService.createUser(req.body);
    res.status(201).json({ success: true, data: newUser });
};

// 내 프로필 조회
export const getMyProfile = async (req, res) => {
    // authMiddleware 에서 req.user = { id: ... } 형태로 넣어준다고 가정
    const userId = req.user.id;
    const profile = await userService.getProfile(userId);
    res.json({ success: true, data: profile });
};

// 내 프로필 수정
export const updateMyProfile = async (req, res) => {
    const userId = req.user.id;
    const updated = await userService.updateProfile(userId, req.body);
    res.json({ success: true, data: updated });
};