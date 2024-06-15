import express from "express";
const router = express.Router();

import { register, login, updateAvailability, fetchDashboardInfo } from "../controllers/healthservice.js";

import { isAuthenticated } from "../middleware/auth.js";


router.route('/register').post(register);
router.route('/login').post(login);
router.route('/update-availability').post(isAuthenticated, updateAvailability);
router.route('/dashboard').get(isAuthenticated, fetchDashboardInfo);

export default router;