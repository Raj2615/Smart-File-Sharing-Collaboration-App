const File = require('../models/file_model');

// GET all files
exports.getFiles = async (req, res) => {
  try {
    const files = await File.find().sort({ updatedAt: -1 });
    res.json(files);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// CREATE new file
exports.createFile = async (req, res) => {
  try {
    const file = new File(req.body);
    const saved = await file.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// UPDATE file
exports.updateFile = async (req, res) => {
  try {
    const updated = await File.findOneAndUpdate(
      { id: req.params.id },
      req.body,
      { new: true } // Return updated document
    );
    if (!updated) return res.status(404).json({ message: 'File not found' });
    res.json(updated);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// DELETE file
exports.deleteFile = async (req, res) => {
  try {
    await File.findOneAndDelete({ id: req.params.id });
    res.json({ message: 'File deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// BULK SYNC — Flutter sends all unsynced files at once
exports.syncFiles = async (req, res) => {
  try {
    const { files } = req.body; // Array of file objects
    
    const results = await Promise.all(
      files.map(async (file) => {
        return File.findOneAndUpdate(
          { id: file.id },
          { ...file, isSynced: true },
          { upsert: true, new: true } // Insert if doesn't exist
        );
      })
    );

    res.json({ synced: results.length, files: results });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};