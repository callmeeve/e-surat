const prisma = require("../config/prisma");

const getAllUsers = async (req, res) => {
  try {
    const users = await prisma.users.findMany({
      include: {
        model_has_roles: {
          include: {
            roles: true,
          },
        },
      },
    });
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil data user" });
  }
};

const me = async (req, res) => {
  const userId = req.user.userId;

  try {
    const user = await prisma.users.findUnique({
      where: { id: userId },
      include: {
        model_has_roles: {
          include: {
            roles: true,
          },
        },
      },
    });

    const roles = user.model_has_roles.map((role) => role.roles.name);

    res.json({ user, roles });
  } catch (error) {
    res.status(500).json({ error: "Gagal mengambil data user" });
  }
};

module.exports = {
  getAllUsers,
  me,
};
