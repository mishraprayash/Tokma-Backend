import express from "express";
const router = express.Router();

import { register, login, fetchDashboardInfo } from "../controllers/foodingandlodging.js";

import { isAuthenticated } from "../middleware/auth.js";

router.route('/register').post(register);
router.route('/login').post(login);
router.route('/dashboard').get(isAuthenticated, fetchDashboardInfo);

export default router;