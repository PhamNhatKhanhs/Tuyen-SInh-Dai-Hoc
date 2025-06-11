const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const path = require('path'); 
const config = require('./config');
const allRoutes = require('./routes');
const errorHandler = require('./middlewares/errorMiddleware');

const app = express();

// CORS configuration for production deployment
const corsOptions = {
  origin: function (origin, callback) {
    // Allow requests with no origin (like mobile apps or Postman)
    if (!origin) return callback(null, true);
    
    const allowedOrigins = [
      'http://localhost:3000',
      'http://localhost:5173',
      'https://localhost:3000',
      'https://localhost:5173',
      process.env.FRONTEND_URL || 'http://localhost:3000'
    ];
    
    // In production, allow all origins for now (can be restricted later)
    if (config.nodeEnv === 'production') {
      return callback(null, true);
    }
    
    if (allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
};

app.use(cors(corsOptions));
if (config.nodeEnv === 'development') { app.use(morgan('dev')); }
app.use(express.json({ limit: '10kb' }));
app.use(express.urlencoded({ extended: true, limit: '10kb' }));

// Serve static files từ thư mục uploads (để có thể truy cập file đã upload qua URL)
// Ví dụ: http://localhost:5001/uploads/documents/filename.pdf
app.use(`/${config.uploadDir}`, express.static(path.join(__dirname, '..', config.uploadDir))); // THÊM MỚI

app.use(allRoutes);
app.all('*', (req, res, next) => { /* ... */ });
app.use(errorHandler);
module.exports = app;