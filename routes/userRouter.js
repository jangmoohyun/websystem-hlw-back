import express from 'express';
import { asyncHandler } from '../middleware/asyncHandler.js';
import * as userController from '../controller/userController.js';
// import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// 유저 조회
router.get('/:id', asyncHandler(userController.getUser));

// 유저 생성
router.post('/', asyncHandler(userController.createUser));

// 프로필 관리
router.get('/me', asyncHandler(userController.getMyProfile));
router.patch('/me', asyncHandler(userController.updateMyProfile));

export default router;