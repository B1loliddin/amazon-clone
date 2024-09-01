const jwt = require("jsonwebtoken");
const User = require("../models/user");

const admin = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).json({ msg: "No auth token, access denied." });
    }

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      return res.status(401).json({ msg: "Token verifiction failed." });
    }

    const user = await User.findById(verified.id);
    if (user.type == "user" || user.type == "seller") {
      return res
        .status(401)
        .json({ msg: "You are not an admin, access denied." });
    }

    req.user = verified.id;
    req.token = token;
    next();
  } catch (e) {
    res.status().json({ error: e.message });
  }
};

module.exports = admin;
