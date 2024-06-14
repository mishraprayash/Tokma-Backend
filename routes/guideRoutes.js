
import express from "express";
const router = express.Router();

import { register, login, fetchDashboardInfo } from "../controllers/guide.js";
import { logout } from "../lib/logout.js";
import { isAuthenticated } from "../middleware/auth.js";


router.route('/register').post(register);
router.route('/login').post(login);
router.route('/dashboard').get(isAuthenticated, fetchDashboardInfo)
router.route('/logout').get(logout)

export default router;