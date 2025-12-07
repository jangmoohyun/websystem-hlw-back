import express from "express";
import { asyncHandler } from "../middleware/asyncHandler.js";
import { authMiddleware } from "../middleware/authMiddleware.js";
import * as problemController from "../controller/problemController.js";

const router = express.Router();

// 문제 조회 (프론트에서 문제 본문과 공개 테스트케이스를 가져올 때 사용)
// Mounted at `/problems` in app, so use `/:id` here to serve GET /problems/:id
router.get("/:id", asyncHandler(problemController.getProblem));

// 코드 제출 엔드포인트 (Judge0를 사용해 채점)
// POST /problems/:storyId/submit-code
router.post(
  "/:storyId/submit-code",
  authMiddleware,
  asyncHandler(problemController.submitCode)
);

export default router;
