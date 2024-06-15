import express from "express"
const router = express.Router()

import { register, login, approveGuide, rejectGuide, fetchDashboardInfo, approveHealthService, rejectHealthService } from "../controllers/admin.js"
import { isAuthenticated } from "../middleware/auth.js"
import { adminAuth } from "../middleware/admin-auth.js"
import { logout } from "../lib/logout.js"

router.route('/register').post(register)
router.route('/login').post(login)
router.route('/dashboard').get(isAuthenticated, adminAuth, fetchDashboardInfo)
router.route('/approve-guide/:id').get(isAuthenticated, adminAuth, approveGuide)
router.route('/reject-guide/:id').get(isAuthenticated, adminAuth, rejectGuide)
router.route('/approve-healthservice/:id').get(isAuthenticated, adminAuth, approveHealthService)
router.route('/reject-healthservice/:id').get(isAuthenticated, adminAuth, rejectHealthService)
router.route('/logout').get(logout)

export default router