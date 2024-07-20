const express = require("express");
const cors = require("cors");
const { config } = require("dotenv");
const path = require("path");

config();

const app = express();

// Import routes
const authRoutes = require("./routes/authRoutes");
const suratMasukRoutes = require("./routes/suratMasukRoutes");
const suratDisposisiRoutes = require("./routes/disposisiRoutes");
const userRoutes = require("./routes/userRoutes");

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.json({ message: "Hello World!" });
});

// Use routes
app.use("/api/auth", authRoutes);
app.use("/api/surat-masuk", suratMasukRoutes);
app.use("/api/surat-disposisi", suratDisposisiRoutes);
app.use("/api/users", userRoutes);

// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, "public")));


app.listen(process.env.PORT, () => {
  console.log(`Server is running on port ${process.env.PORT}`);
});
