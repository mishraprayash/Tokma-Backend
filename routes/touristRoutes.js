import express from "express";
const router = express.Router();

import { register,login } from "../controllers/tourist.js";
import { logout } from "../lib/logout.js";
import { isAuthenticated } from "../middleware/auth.js";

router.route('/register').post(register);
router.route('/login').post(login);

export default router