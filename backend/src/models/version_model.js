const mongoose = require('mongoose');

const versionSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  fileId: { type: String, required: true, index: true }, // Foreign key to File
  versionNumber: { type: Number, required: true },
  description: { type: String, default: '' },
  createdBy: { type: String, default: 'Me' },
  isConflict: { type: Boolean, default: false },
}, {
  timestamps: true,
});

module.exports = mongoose.model('Version', versionSchema);