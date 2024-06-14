import express from "express";
const router = express.Router();

import { register, login, detail } from "../controllers/tourist.js";
import { logout } from "../lib/logout.js";
import { isAuthenticated } from "../middleware/auth.js";
import { nearbyHealth } from "../controllers/healthservice.js";

router.route("/register").post(register);
router.route("/login").post(login);
router.route("/health").post(nearbyHealth);
router.route("/detail").get(isAuthenticated, detail);

export default router;
