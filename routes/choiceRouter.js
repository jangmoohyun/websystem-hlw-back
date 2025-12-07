import express from "express";
import { asyncHandler } from "../middleware/asyncHandler.js";
import { authMiddleware } from "../middleware/authMiddleware.js";
import * as choiceController from "../controller/choiceController.js";

const router = express.Router();

// 선택지 선택 처리
router.post("/select", authMiddleware, asyncHandler(choiceController.selectChoice));

export default router;
