import healthService from "../models/healthserviceModel.js"

export const register = async (req, res, next) => {
    const { name, contactNo, email, password, description, geoLocation } = req.body;
    if (!name || !contactNo || !email || !password || !geoLocation || !description) {
        return res.json({ message: "Missing informations" });
    }
    const user = await healthService.findOne({ email });
    if (user) {
        return res.json({ message: "User already exists" })
    }
    const hashedPassword = await bcrypt.hash(password, 10);

    const healthservice = await healthService.create({
        name, contactNo, email, description, geoLocation,
        password: hashedPassword
    })
    return res.json({ message: "Register Success", healthservice });
}


export const login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.json({ message: "Missing information" });
        }
        const healthservice = await healthService.findOne({ email });
        if (!healthservice) {
            return res.json({ message: "User doesnot exists" });
        }
        const isPasswordMatched = await healthservice.matchPassword(password);
        if (!isPasswordMatched) {
            return res.json({ message: "User doesnot exist" });
        }
        // remaining to handle create session here 
        const token = healthservice.createJWT();
        res.cookie('token', token, {
            httpOnly: true,
            secure: false,
            maxAge: 24 * 60 * 60 * 1000 // 1 day
        });
        return res.status(200).json({ message: "Login Success", userId: healthService._id, token });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error })
    }
}

export const serviceStatus = async (req, res, next) => {
    try {
        const userid = req.user.id;
        const { lat, lon } = req.body
        const healthservice = await healthService.findById(userid)
        healthservice.geoLocation.coordinates = [lon, lat];
        const status = healthservice.isAvailable
        healthservice.isAvailable = !status
        await healthservice.save()
        return res.status(200).json({ status: `${healthservice.isAvailable}` })
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error })
    }
}

export const fetchDashboardInfo = async (req, res, next) => {
    try {
        const guide = await healthService.find({ _id: req.user.id }, { password: false })
        if (!guide) {
            return res.status(400).json({ message: "Guide doesnot exists" })
        }
        return res.status(200).json({ guide })

    } catch (error) {
        console.log(error);
        return res.status(500).json({ error })
    }
}