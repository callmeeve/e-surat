// suratDisposisiController.js
const prisma = require("../config/prisma");

// Get all Surat Disposisi
const getAllSuratDisposisi = async (req, res) => {
  const userId = req.user.userId;

  if (!userId) {
    return res.status(401).json({ error: "User tidak ditemukan" });
  }

  try {
    const suratDisposisi = await prisma.surat_disposisis.findMany({
      where: { user_id: userId },
      include: {
        surat_masuks: true,
      },
    });
    res.json(suratDisposisi);
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil data surat disposisi" });
  }
};

// Get Surat Disposisi by ID
const getSuratDisposisiById = async (req, res) => {
  const { id } = req.params;

  try {
    const suratDisposisi = await prisma.surat_disposisis.findUnique({
      where: { id: parseInt(id) },
      include: {
        surat_masuks: true,
      },
    });
    if (!suratDisposisi) {
      return res.status(404).json({ error: "Surat disposisi tidak ditemukan" });
    }
    res.json(suratDisposisi);
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil data surat disposisi" });
  }
};

// Create Surat Disposisi (baru)
const createSuratDisposisiAndUpdateSuratMasuk = async (req, res) => {
  const {
    surat_masuk_id,
    user_id,
    induk,
    waktu,
    disposisi_singkat,
    disposisi_narasi,
  } = req.body;

  try {
    const result = await prisma.$transaction(async (prisma) => {

      const targetUser = await prisma.users.findUnique({
        where: {
          id: parseInt(user_id),
        },
        select: {
          name: true,
        },
      });

      if (!targetUser) {
        return res.status(404).json({ error: "User tidak ditemukan" });
      }

      // Membuat surat disposisi baru
      const suratDisposisi = await prisma.surat_disposisis.create({
        data: {
          surat_masuk_id: parseInt(surat_masuk_id),
          user_id: parseInt(user_id),
          induk: parseInt(induk),
          waktu: new Date(waktu),
          disposisi_singkat,
          disposisi_narasi,
          tujuan_disposisi: targetUser.name,
          jenis: "turun",
          status: "proses",
          created_at: new Date(),
          updated_at: new Date(),
        },
      });

      // Mengambil nama user dan roles berdasarkan user_id
      const userWithRoles = await prisma.users.findUnique({
        where: {
          id: parseInt(user_id),
        },
        select: {
          name: true,
          model_has_roles: {
            select: {
              roles: {
                select: {
                  name: true,
                },
              },
            },
          },
        },
      });

      if (!userWithRoles) {
        return res.status(404).json({ error: "User tidak ditemukan" });
      }

      // Status surat masuk berdasarkan role user
      const roleName = userWithRoles.model_has_roles[0].roles.name.toLocaleLowerCase();
      const statusMap = {
        proses: 1,
        direktur: 2,
        wadir: 3,
        pegawai: 4,
        arsip: 5,
      };

      const suratStatus = statusMap[roleName] || 1;

      // Memperbarui status dan disposisi surat masuk
      const updatedSuratMasuk = await prisma.surat_masuks.update({
        where: {
          id: parseInt(surat_masuk_id),
        },
        data: {
          status: suratStatus, // Gunakan suratStatus yang sudah ditentukan
          disposisi: userWithRoles.name, // Gunakan nama user yang ditemukan
        },
      });

      return { suratDisposisi, updatedSuratMasuk };
    });

    res.status(201).json(result);
  } catch (error) {
    console.log(error);
    res.status(500).json({
      error: "Gagal membuat surat disposisi dan memperbarui surat masuk",
    });
  }
};

// Update Surat Disposisi
const updateSuratDisposisi = async (req, res) => {
  const { id } = req.params;
  const {
    surat_masuk_id,
    user_id,
    induk,
    waktu,
    disposisi_singkat,
    disposisi_narasi,
    tujuan_disposisi,
    jenis,
    status,
  } = req.body;
  try {
    const suratDisposisi = await prisma.surat_disposisis.update({
      where: { id: parseInt(id) },
      data: {
        surat_masuk_id: parseInt(surat_masuk_id),
        user_id: parseInt(user_id),
        induk: parseInt(induk),
        waktu: new Date(waktu),
        disposisi_singkat,
        disposisi_narasi,
        tujuan_disposisi,
        jenis,
        status,
      },
    });
    res.json(suratDisposisi);
  } catch (error) {
    res.status(500).json({ error: "Gagal mengupdate surat disposisi" });
  }
};

// Mengirim Surat Disposisi
const followUpDisposisi = async (req, res) => {
  const { id } = req.params;

  try {
    const disposisi = await prisma.surat_disposisis.update({
      where: { id: parseInt(id) },
      data: {
        status: "selesai",
      },
    });
    res.status(200).json(disposisi);
  } catch (error) {
    print(error);
    res.status(500).json({ error: "Gagal mengirim surat disposisi" });
  }
};

// Delete Surat Disposisi
const deleteSuratDisposisi = async (req, res) => {
  const { id } = req.params;
  try {
    await prisma.surat_disposisis.delete({
      where: { id: parseInt(id) },
    });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: "Gagal menghapus surat disposisi" });
  }
};

module.exports = {
  getAllSuratDisposisi,
  getSuratDisposisiById,
  createSuratDisposisiAndUpdateSuratMasuk,
  followUpDisposisi,
  updateSuratDisposisi,
  deleteSuratDisposisi,
};
