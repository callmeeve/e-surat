const express = require('express');
const router = express.Router();
const { getAllUsers, me } = require('../controllers/userController');
const { authenticate, authorize } = require('../middleware/authMiddleware');

router.get('/', authenticate, authorize(["Direktur", "Wadir"]), getAllUsers);
router.get('/me', authenticate, authorize(["Direktur", "Wadir", "Pegawai"]), me);

module.exports = router;