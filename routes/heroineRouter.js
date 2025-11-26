import express from 'express';
import { asyncHandler } from '../middleware/asyncHandler.js';
// import { authMiddleware } from '../middleware/authMiddleware.js';
import * as heroineController from '../controller/heroineController.js';

const router = express.Router();

// 히로인 전체 목록
router.get('/', asyncHandler(heroineController.getHeroines));

// 히로인 상세
router.get('/:id', asyncHandler(heroineController.getHeroineById));

// (선택) 슬롯 기준 히로인 호감도
router.get(
    '/likes/by-slot',
    asyncHandler(heroineController.getHeroineLikesBySlot)
);

export default router;