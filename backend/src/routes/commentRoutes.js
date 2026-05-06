const express = require('express');
const router = express.Router();
const {
  getCommentsForFile,
  addComment,
  deleteComment,
  syncComments,
} = require('../controllers/commentController');

router.get('/:fileId', getCommentsForFile);   // GET /api/comments/:fileId
router.post('/', addComment);                 // POST /api/comments
router.delete('/:id', deleteComment);         // DELETE /api/comments/:id
router.post('/sync', syncComments);           // POST /api/comments/sync

module.exports = router;
