import express from "express";
const router = express.Router();

import { register, login } from "../controllers/healthservice.js";

import { isAuthenticated } from "../middleware/auth.js";


router.route('/register').post(register);
router.route('/login').post(login);
router.route('/availabilitystatus/').post(isAuthenticated, serviceStatus);
router.route('/dashboard').get(isAuthenticated, fetchDashboardInfo);

export default router;