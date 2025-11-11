import express from 'express';
import { asyncHandler } from '../middleware/asyncHandler.js';
import * as userController from '../controller/userController.js';

const router = express.Router();

/* GET users listing. */
router.get('/', asyncHandler(userController.getUser));

export default router;
