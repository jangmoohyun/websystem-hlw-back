import express from 'express';
import { asyncHandler } from '../middleware/asyncHandler.js';
// import { authMiddleware } from '../middleware/authMiddleware.js';
import * as progressController from '../controller/progressController.js';

const router = express.Router();

// 전체 세이브 슬롯 목록
router.get(
    '/saves',
    asyncHandler(progressController.getSaves)
);

// 세이브 저장/덮어쓰기
router.put(
    '/save',
    asyncHandler(progressController.saveGame)
);

// 세이브 불러오기
router.get(
    '/save',
    asyncHandler(progressController.loadGame)
);

export default router;
