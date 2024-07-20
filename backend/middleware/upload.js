const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Ensure the upload directory exists
const folderPath = path.join(__dirname, "../public/uploads");
if (!fs.existsSync(folderPath)) {
  try {
    fs.mkdirSync(folderPath, { recursive: true });
  } catch (error) {
    console.error("Failed to create upload directory:", error);
    // Handle errors or exit process if the directory can't be created
  }
}

// Storage configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, folderPath);
  }
});

// File filter configuration
const fileFilter = (req, file, cb) => {
  if (file.mimetype === "application/pdf") {
    cb(null, true);
  } else {
    // Provide an error message for unsupported file types
    cb(new Error("Only PDF files are allowed"), false);
  }
};

// Upload configuration
const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 1024 * 1024 * 5, // 5 MB
  },
});

module.exports = upload;