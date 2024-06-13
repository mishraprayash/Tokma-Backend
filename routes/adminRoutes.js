import express from "express"
const router = express.Router()

import { register, login, approveGuide, rejectGuide, logout,fetchDashboardInfo, } from "../controllers/admin.js"
import { isAuthenticated } from "../middleware/auth.js"

router.route('/register').post(register)
router.route('/login').post(login)
router.route('/dashboard').get(isAuthenticated,fetchDashboardInfo)
router.route('/approve/:id').get(isAuthenticated, approveGuide)
router.route('/reject/:id').get(isAuthenticated, rejectGuide)
router.route('/logout').get(logout)

export default router