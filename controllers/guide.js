import Guide from "../models/guide.js";

export const register = async (req, res, next) => {
    const { name, contactNo, gender, age } = req.body;
    if (!name || !contactNo || !gender || !age) {
        return res.json({ message: "Missing informations" });
    }
    const user = await Guide.create({
        ...req.body
    })
    return res.json({ user });
}

export const login = async (req, res, next) => {

}
