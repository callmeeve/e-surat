const prisma = require("../config/prisma");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

// Register User
const register = async (req, res) => {
  const { name, email, password, role } = req.body;

  const hashedPassword = await bcrypt.hash(password, 10);

  const user = await prisma.users.create({
    data: {
      name,
      email,
      password: hashedPassword,
      model_has_roles: {
        create: {
          roles: {
            connect: { name: role }, // Asumsikan role sudah ada dalam tabel roles
          },
        },
      },
    },
  });

  res.json({ message: "User registered successfully", user });
};

// Login User
const login = async (req, res) => {
  const { username, password } = req.body;

  const user = await prisma.users.findUnique({
    where: { username },
    include: {
      model_has_roles: {
        include: {
          roles: true,
        },
      },
    },
  });

  if (!user) {
    return res.status(400).json({ message: "Invalid username or password" });
  }

  const isPasswordValid = await bcrypt.compare(password, user.password);

  if (!isPasswordValid) {
    return res.status(400).json({ message: "Invalid username or password" });
  }

  const roles = user.model_has_roles.map((role) => role.roles.name);

  const token = jwt.sign(
    {
      userId: user.id,
      roles: roles,
    },
    process.env.JWT_SECRET,
    { expiresIn: "1h" }
  );

  res.json({ message: "Login successful", token, roles });
};

module.exports = {
  register,
  login,
};
