// suratMasukController.js
const prisma = require("../config/prisma");

// Get Surat Masuk Report
const getAllSuratMasuk = async (req, res) => {
  try {
    const suratMasuk = await prisma.surat_masuks.findMany();
    res.json(suratMasuk);
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil data surat masuk" });
  }
};

// Get Surat Masuk by ID
const getSuratMasukById = async (req, res) => {
  const { id } = req.params;
  try {
    const suratMasuk = await prisma.surat_masuks.findUnique({
      where: { id: parseInt(id) },
    });
    if (!suratMasuk) {
      return res.status(404).json({ error: "Surat masuk tidak ditemukan" });
    }
    res.json(suratMasuk);
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil data surat masuk" });
  }
};

// Menerima data surat masuk
const createSuratMasuk = async (req, res) => {
  const {
    induk,
    nomor,
    tanggal_surat,
    tanggal_diterima,
    pengirim,
    diterima_dari,
    perihal,
    sifat,
    disposisi,
    status,
    user_id,
    catatan_sekretariat,
    file,
  } = req.body;

  // Status surat masuk
  const statusMap = {
    1: 'proses',
    2: 'direktur',
    3: 'wadir',
    4: 'pegawai',
    5: 'arsip',
  };

  const suratStatus = statusMap[status];

  if (!suratStatus) {
    return res.status(400).json({ error: 'Status surat tidak valid' });
  }

  try {
    const suratMasuk = await prisma.surat_masuks.create({
      data: {
        induk,
        nomor,
        tanggal_surat: new Date(tanggal_surat),
        tanggal_diterima: new Date(tanggal_diterima),
        pengirim,
        diterima_dari,
        perihal,
        sifat,
        disposisi,
        status: suratStatus,
        user_id,
        catatan_sekretariat,
        file,
      },
    });
    res.status(201).json(suratMasuk);
  } catch (error) {
    res.status(500).json({ error: "Failed to create surat masuk" });
  }
};

// Update Surat Masuk
const updateSuratMasuk = async (req, res) => {
  const { id } = req.params;
  const {
    induk,
    nomor,
    tanggal_surat,
    tanggal_diterima,
    pengirim,
    diterima_dari,
    perihal,
    sifat,
    disposisi,
    status,
    user_id,
    catatan_sekretariat,
    file,
  } = req.body;
  try {
    const suratMasuk = await prisma.surat_masuks.update({
      where: { id: parseInt(id) },
      data: {
        induk,
        nomor,
        tanggal_surat: new Date(tanggal_surat),
        tanggal_diterima: new Date(tanggal_diterima),
        pengirim,
        diterima_dari,
        perihal,
        sifat,
        disposisi,
        status,
        user_id,
        catatan_sekretariat,
        file,
      },
    });
    res.json(suratMasuk);
  } catch (error) {
    res.status(500).json({ error: "Failed to update surat masuk" });
  }
};

// Delete Surat Masuk
const deleteSuratMasuk = async (req, res) => {
  const { id } = req.params;
  try {
    await prisma.surat_masuks.delete({
      where: { id: parseInt(id) },
    });
    res.json({ message: "Surat Masuk deleted" });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete surat masuk" });
  }
};

module.exports = {
  getAllSuratMasuk,
  getSuratMasukById,
  createSuratMasuk,
  updateSuratMasuk,
  deleteSuratMasuk,
};
