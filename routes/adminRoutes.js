import express from "express"
const router = express.Router()

import { register, login, approveGuide, rejectGuide, fetchDashboardInfo, } from "../controllers/admin.js"
import { isAuthenticated } from "../middleware/auth.js"
import { adminAuth } from "../middleware/admin-auth.js"
import { logout } from "../lib/logout.js"

router.route('/register').post(register)
router.route('/login').post(login)
router.route('/dashboard').get(isAuthenticated, adminAuth, fetchDashboardInfo)
router.route('/approve/:id').get(isAuthenticated, adminAuth, approveGuide)
router.route('/reject/:id').get(isAuthenticated, adminAuth, rejectGuide)
router.route('/logout').get(logout)

export default router