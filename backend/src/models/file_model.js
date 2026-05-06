const mongoose = require('mongoose');

const fileSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  fileName: { type: String, required: true },
  fileType: { type: String, required: true },
  description: { type: String, default: '' },
  isShared: { type: Boolean, default: false },
  isSynced: { type: Boolean, default: true },
  currentVersion: { type: Number, default: 1 },
  owner: { type: String, default: 'Me' },
}, {
  timestamps: true, // Adds createdAt and updatedAt automatically
});

module.exports = mongoose.model('File', fileSchema);
