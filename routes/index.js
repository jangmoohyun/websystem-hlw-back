import express from 'express';
const router = express.Router();

/* GET home page - Health Check용 */
router.get('/', (req, res) => {
    // ALB Health Check를 위한 단순 200 응답
    res.status(200).json({ 
        status: 'ok', 
        message: 'Task is Healthy',
        timestamp: new Date().toISOString()
    });
});

export default router;
