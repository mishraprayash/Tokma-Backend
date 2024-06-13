import Tourist from "../models/touristModel.js";

export const register = async (req, res, next) => {
    try {
        const { name, contactNo, gender, age } = req.body;
        if (!name || !contactNo || !gender || !age) {
            return res.json({ message: "Missing informations" });
        }
        const tourist = await Guide.create({
            ...req.body
        })
        return res.json({ tourist });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error });
    }
}

export const login = async (req, res, next) => {
    try {
        const { username,password} = req.body;
        if (!username || !password) {
            return res.json({ message: "Missing informations" });
        }
       
        return res.json({  });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error });
    }
}