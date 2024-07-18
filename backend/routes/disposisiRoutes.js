const express = require("express");
const router = express.Router();

// Import controller
const {
  getAllSuratDisposisi,
  getSuratDisposisiById,
  createSuratDisposisiAndUpdateSuratMasuk,
  followUpDisposisi,
  updateSuratDisposisi,
  deleteSuratDisposisi,
} = require("../controllers/suratDisposisiController");

// Import middleware
const { authenticate, authorize } = require("../middleware/authMiddleware");

// Route for getting all "Surat Disposisi" - accessible by Direktur, Wadir, and Pegawai
router.get("/", [authenticate, authorize(["Direktur", "Wadir", "Pegawai"])], getAllSuratDisposisi);


// Route for getting, updating, and deleting a specific "Surat Disposisi" by ID
router
  .route("/:id")
  .get([authenticate, authorize(["Direktur", "Wadir"])], getSuratDisposisiById)
  .put([authenticate, authorize(["Direktur", "Wadir"])], updateSuratDisposisi)
  .delete(
    [authenticate, authorize(["Direktur", "Wadir"])],
    deleteSuratDisposisi
  );

// Route for creating a new "Surat Disposisi" - accessible by Direktur, Wadir, and Pegawai
router.post(
  "/",
  [authenticate, authorize(["Direktur", "Wadir"])],
  createSuratDisposisiAndUpdateSuratMasuk
);

// Route for following up a "Surat Disposisi" - accessible by Direktur, Wadir, and Pegawai
router.patch(
  "/follow-up/:id",
  [authenticate, authorize(["Direktur", "Wadir"])],
  followUpDisposisi
);

module.exports = router;
