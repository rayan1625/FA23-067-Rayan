const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const { addMetric, getMetrics } = require('../controllers/health.controller');

router.post('/', authMiddleware, addMetric);
router.get('/', authMiddleware, getMetrics);

module.exports = router;
