import jwt from "jsonwebtoken";
import JsonWebTokenError from "jsonwebtoken/lib/JsonWebTokenError.js";

export const isAuthenticated = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(403).json({ message: "Unauthorized Access" });
    }
    const token = authHeader.split(" ")[1];
    if (!token) {
      return res.status(403).json({ message: "Unauthorized Access" });
    }
    const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decodedToken;
    next();
  } catch (error) {
    if (error instanceof JsonWebTokenError) {
      return res.status(403).json({ message: "Unauthorized Access" });
    }
    return res.status(500).json({ error });
  }
};