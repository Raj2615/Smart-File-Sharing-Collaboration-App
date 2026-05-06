const express = require('express');
const router = express.Router();
const {
  getFiles,
  createFile,
  updateFile,
  deleteFile,
  syncFiles,
} = require('../controllers/fileController');

router.get('/', getFiles);          // GET /api/files
router.post('/', createFile);       // POST /api/files
router.put('/:id', updateFile);     // PUT /api/files/:id
router.delete('/:id', deleteFile);  // DELETE /api/files/:id
router.post('/sync', syncFiles);    // POST /api/files/sync (bulk sync)

module.exports = router;