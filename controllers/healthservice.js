import healthService from "../models/healthserviceModel.js"
import bcrypt from "bcryptjs"
export const register = async (req, res, next) => {
    const { name, contactNo, email, password, description, location } = req.body
    if (!name || !contactNo || !email || !password || !description || !location) {
        return res.status(400).json({ message: "Missing informations" })
    }
    const user = await healthService.findOne({ email })
    if (user) {
        return res.status(400).json({ message: "User already exists" })
    }
    const hashedPassword = await bcrypt.hash(password, 10)

    const healthservice = new healthService({
        name, contactNo, email, description, regionalLocation: location,
        password: hashedPassword,
    })
    await healthservice.save()
    return res.json({ message: "Register Success", healthservice })
}

export const login = async (req, res, next) => {
    try {
        const { email, password } = req.body
        if (!email || !password) {
            return res.json({ message: "Missing information" })
        }
        const healthservice = await healthService.findOne({ email })
        if (!healthservice) {
            return res.json({ message: "User doesnot exists" })
        }
        const isPasswordMatched = await healthservice.matchPassword(password)
        if (!isPasswordMatched) {
            return res.json({ message: "User doesnot exist" })
        }
        // remaining to handle create session here 
        const token = healthservice.createJWT()

        return res.status(200).json({ message: "Login Success", token })
    } catch (error) {
        console.log(error)
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
        console.log(error)
        return res.status(500).json({ error })
    }
}

export const updateAvailability = async (req, res, next) => {
    try {
        const { lat, lon } = req.body
        const healthservice = await healthService.findOne({ email: req.user.email })
        const status = healthservice.isAvailable
        healthservice.isAvailable = !status
        healthservice.geoLocation.type = "Point"
        healthservice.geoLocation.coordinates = [lon, lat]
        await healthservice.save()
        return res.status(200).json({ availablility: `${healthservice.isAvailable}` })
        
    } catch (error) {
        console.log(error)
        return res.status(500).json({ error })
    }
}

