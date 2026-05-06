const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  fileId: { type: String, required: true, index: true }, // Foreign key to File
  text: { type: String, required: true },
  author: { type: String, default: 'Me' },
  isSynced: { type: Boolean, default: true },
}, {
  timestamps: true,
});

module.exports = mongoose.model('Comment', commentSchema);
