const Version = require('../models/version_model');

// GET all versions for a file
exports.getVersionsForFile = async (req, res) => {
  try {
    const versions = await Version
      .find({ fileId: req.params.fileId })
      .sort({ versionNumber: 1 }); // Oldest → newest
    res.json(versions);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// CREATE a version
exports.createVersion = async (req, res) => {
  try {
    const version = new Version(req.body);
    const saved = await version.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// BULK SYNC versions from Flutter
exports.syncVersions = async (req, res) => {
  try {
    const { versions } = req.body;

    const results = await Promise.all(
      versions.map((v) =>
        Version.findOneAndUpdate(
          { id: v.id },
          v,
          { upsert: true, new: true }
        )
      )
    );

    res.json({ synced: results.length });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};