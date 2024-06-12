import express from "express";
const router = express.Router();

import { register,login } from "../controllers/admin.js";

router.route('/register').post(register);
router.route('/login').post(login);

export default router;