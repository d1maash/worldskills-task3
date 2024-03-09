const express = require("express");
const router = express.Router();
router.post("/register", (req, res) => {
  res.json({ msg: "Register Route" });
});

router.post("/login", (req, res) => {
  res.json({ msg: "Login route" });
});

module.exports = router;
