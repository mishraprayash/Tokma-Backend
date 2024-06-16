import express from "express";
const router = express.Router();

import { register, login, fetchDashboardInfo, fetchIndividualServiceFromTourist, updateAvailability } from "../controllers/foodingandlodging.js";

import { isAuthenticated } from "../middleware/auth.js";

router.route('/register').post(register);
router.route('/login').post(login);
router.route('/dashboard').get(isAuthenticated, fetchDashboardInfo);
router.route('/individual-service').post(isAuthenticated, fetchIndividualServiceFromTourist)
router.route('/update-availability').get(isAuthenticated, updateAvailability)

export default router;