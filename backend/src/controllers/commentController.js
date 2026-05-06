const Comment = require('../models/comment_model');

// GET all comments for a file
exports.getCommentsForFile = async (req, res) => {
  try {
    const comments = await Comment
      .find({ fileId: req.params.fileId })
      .sort({ createdAt: -1 }); // Newest first
    res.json(comments);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ADD a comment
exports.addComment = async (req, res) => {
  try {
    const comment = new Comment(req.body);
    const saved = await comment.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// DELETE a comment
exports.deleteComment = async (req, res) => {
  try {
    await Comment.findOneAndDelete({ id: req.params.id });
    res.json({ message: 'Comment deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// BULK SYNC comments from Flutter
exports.syncComments = async (req, res) => {
  try {
    const { comments } = req.body;

    const results = await Promise.all(
      comments.map((c) =>
        Comment.findOneAndUpdate(
          { id: c.id },
          c,
          { upsert: true, new: true }
        )
      )
    );

    res.json({ synced: results.length });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};