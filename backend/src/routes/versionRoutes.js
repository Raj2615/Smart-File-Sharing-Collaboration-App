const express = require('express');
const router = express.Router();
const {
  getVersionsForFile,
  createVersion,
  syncVersions,
} = require('../controllers/versionController');

router.get('/:fileId', getVersionsForFile);   // GET /api/versions/:fileId
router.post('/', createVersion);              // POST /api/versions
router.post('/sync', syncVersions);           // POST /api/versions/sync

module.exports = router;