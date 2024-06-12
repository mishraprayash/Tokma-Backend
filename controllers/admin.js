import Admin from "../models/admin.js";

export const register = async (req, res, next) => {
    const { username,email,password } = req.body;
    if (!password || !username|| !email) {
        return res.json({ message: "Missing informations" });
    }
    const admin = await Admin.create({
        ...req.body
    })
    return res.json({ admin });
}

export const login = async (req, res, next) => {
    
}