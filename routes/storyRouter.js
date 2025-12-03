import express from "express";
import { asyncHandler } from "../middleware/asyncHandler.js";
import * as storyController from "../controller/storyController.js";

const router = express.Router();

// 스토리 목록
router.get("/", asyncHandler(storyController.getStories));

// 스토리 상세 + 스크립트
router.get("/:id", asyncHandler(storyController.getStoryById));
// 스토리에 연결된 문제 목록 조회(공개 테스트케이스 포함)
router.get("/:id/problems", asyncHandler(storyController.getProblemsByStory));

export default router;
