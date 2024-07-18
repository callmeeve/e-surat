// authMiddleware.js
const jwt = require('jsonwebtoken');

// Middleware untuk memeriksa token JWT
const authenticate = async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Access token required' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    res.status(401).json({ message: 'Invalid or expired token' });
  }
};

// Middleware untuk otorisasi berdasarkan peran
const authorize = (roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.roles[0])) {
      return res.status(403).json({ message: 'Access denied' });
    }
    next();
  };
};

module.exports = {
  authenticate,
  authorize,
};
