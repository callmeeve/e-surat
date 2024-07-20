const express = require("express");
const router = express.Router();

// Import controller
const {
  getAllSuratMasuk,
  getSuratMasukById,
  createSuratMasuk,
  updateSuratMasuk,
  deleteSuratMasuk
} = require("../controllers/suratMasukController");

// Import middleware
const { authenticate, authorize } = require("../middleware/authMiddleware");
const upload = require("../middleware/upload");

// Route for getting all "Surat Masuk" - accessible by Direktur, Wadir, and Pegawai
router.get("/", [authenticate, authorize(["Direktur", "Wadir", "Pegawai"])], getAllSuratMasuk);

// Route for creating a new "Surat Masuk" - accessible by Direktur, Wadir, and Pegawai
router.post("/", [authenticate], upload.single("file"), createSuratMasuk);


// Route for getting, updating, and deleting a specific "Surat Masuk" by ID
router.route("/:id")
  .get([authenticate, authorize(["Direktur", "Wadir", "Pegawai"])], getSuratMasukById) // Get a specific "Surat Masuk" by ID
  .put([authenticate, authorize(["Direktur", "Wadir", "Pegawai"])], updateSuratMasuk) // Update a specific "Surat Masuk" by ID
  .delete([authenticate, authorize(["Direktur", "Wadir", "Pegawai"])], deleteSuratMasuk); // Delete a specific "Surat Masuk" by ID

module.exports = router;