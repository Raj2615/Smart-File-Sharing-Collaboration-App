// Entry point for the backend
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const connectDB = require('./src/config/db');
const fileRoutes = require('./src/routes/fileRoutes');
const versionRoutes = require('./src/routes/versionRoutes');
const commentRoutes = require('./src/routes/commentRoutes');
const errorHandler = require('./src/middleware/errorHandler');

const app = express();

// Allow Flutter app to call this API
app.use(cors());
app.use(express.json()); // Parse JSON request bodies

// Connect to MongoDB
connectDB();

// Register routes
app.use('/api/files', fileRoutes);
app.use('/api/versions', versionRoutes);
app.use('/api/comments', commentRoutes);

// Global error handler (must be last)
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));