import express from "express";
const router = express.Router();

import { register, login, updateAvailability, fetchDashboardInfo } from "../controllers/foodandlodging.js";

import { isAuthenticated } from "../middleware/auth.js";


router.route('/register').post(register);
router.route('/login').post(login);
router.route('/dashboard').get(isAuthenticated, fetchDashboardInfo);

export default router;