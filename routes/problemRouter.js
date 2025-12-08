import express from "express";
import { asyncHandler } from "../middleware/asyncHandler.js";
import { authMiddleware } from "../middleware/authMiddleware.js";
import * as problemController from "../controller/problemController.js";

const router = express.Router();

// 문제 조회는 이제 스토리 엔드포인트(`/stories/:id/problems` 또는
// `/stories/:id/node/:nodeIndex/problem`)를 통해 처리합니다.
// 이전에 제공하던 `GET /problems/:id` 라우트는 제거되었습니다.

// 코드 제출 엔드포인트 (Judge0를 사용해 채점)
// POST /problems/:storyId/submit-code
router.post(
  "/:storyId/submit-code",
  authMiddleware,
  asyncHandler(problemController.submitCode)
);

export default router;
