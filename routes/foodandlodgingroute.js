import express from "express";
const router = express.Router();

import { register, login, fetchDashboardInfo, fetchIndividualServiceFromTourist } from "../controllers/foodingandlodging.js";

import { isAuthenticated } from "../middleware/auth.js";

router.route('/register').post(register);
router.route('/login').post(login);
router.route('/dashboard').get(isAuthenticated, fetchDashboardInfo);
router.route('/individual-service').post(isAuthenticated, fetchIndividualServiceFromTourist)

export default router;