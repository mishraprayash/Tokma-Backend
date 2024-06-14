import Tourist from "../models/touristModel.js";

export const register = async (req, res, next) => {
    try {
        const {
            firstName,
            lastName,
            contactNo,
            country,
            gender,
            email,
            age,
            password,
        } = req.body;
        if (
            !firstName ||
            !lastName ||
            !contactNo ||
            !country ||
            !gender ||
            !email ||
            !age ||
            !password ||
            !phoneNo
        ) {
            return res.json({ message: "Missing informations" });
        }
        const user = await Tourist.findOne({ email });
        if (user) {
            return res.status(400).json({ message: "User already exists" });
        }
        const hashedPassword = await bcrypt.hash(password, 10);

        const tourist = await Tourist.create({
            firstName,
            lastName,
            contactNo,
            country,
            gender,
            email,
            age,
            password: hashedPassword,
        });
        return res.json({ msg: "Successfully created", tourist });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error });
    }
};
export const detail = async (req, res, next) => {
    const user = req.user;
    console.log(user);
    res.json({ data: user });
    // try{
    //   // const userDetail=await Tourist.find
    // }
};
export const login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.json({ message: "Missing informations" });
        }

        return res.json({});
    } catch (error) {
        console.log(error);
        res.status(500).json({ error });
    }
};


export const nearbyHealth = async (req, res, next) => {
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
        return res.status(201).json({ message: "Results", locations });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error });
    }
};