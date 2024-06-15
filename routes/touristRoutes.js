import express from "express"
const router = express.Router()

import { register, login, nearbyHealthServices, nearbyLocalGuides, updateLocation, fetchAllService,touristInfo } from "../controllers/tourist.js"
import { logout } from "../lib/logout.js";
import { isAuthenticated } from "../middleware/auth.js"

router.route('/register').post(register);
router.route('/login').post(login);
router.route('/logout').get(logout);
router.route('/nearby-healthservice').get(isAuthenticated, nearbyHealthServices)
router.route('/nearby-guide').get(isAuthenticated, nearbyLocalGuides)
router.route('/update-location').post(isAuthenticated, updateLocation)
router.route('/services').get(isAuthenticated, fetchAllService)
router.route('/info').get(isAuthenticated,touristInfo)
export default router