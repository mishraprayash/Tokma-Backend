import Tourist from "../models/touristModel.js";
import bcrypt from "bcryptjs"

export const register = async (req, res, next) => {
    try {
        const {firstName, lastName, contactNo, country, gender, email, age, password, emergencyEmail, emergencyNumber } = req.body;
        if (!firstName || !lastName || !contactNo || !country || !gender || !email || !age || !password || !emergencyEmail || !emergencyNumber) {
            return res.status(400).json({ message: "Missing informations" });
        }
        const user = await Tourist.findOne({ email });
        if (user) {
            return res.status(400).json({ message: "User already exists" });
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        const tourist = await Tourist.create({ firstName, lastName, contactNo, country, gender, email, age, password: hashedPassword, emergencyEmail, emergencyNumber });
        return res.status(200).json({ messageg: "Registered Successfully"});
    } catch (error) {
        console.log(error);
        res.status(500).json({ error });
    }
};

export const login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ message: "Missing informations" });
        }
        const tourist = await Tourist.findOne({ email })
        if (!email) {
            return res.status(400).json({ message: "User doesnot exist" })
        }
        const isPasswordMatch = await tourist.matchPassword(password)
        if (!isPasswordMatch) {
            return res.status(400).json({ message: "User doesnot exist" })
        }
        const token = tourist.createJWT()

        res.cookie('token', token, {
            httpOnly: true,
            maxAge: 24 * 60 * 60 * 100,
        });
        return res.status(200).json({ message: "Login Success", token });

    } catch (error) {
        console.log(error);
        res.status(500).json({ error });
    }
};


export const nearbyHealthServices = async (req, res, next) => {
    const { lat, lon } = req.body;
    let locations;
    try {
        locations = await healthService.find({
            geoLocation: {
                $near: {
                    $geometry: {
                        type: "Point",
                        coordinates: [lon, lat],
                    },
                    $maxDistance: 1000, //1000 m =1km
                },
            },
        });
        return res.status(200).json({ message: "Results", locations });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error });
    }
};