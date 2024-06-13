import Admin from "../models/admin.js"
import Guide from "../models/guide.js"
import Tourist from "../models/tourist.js"
import mongoose from "mongoose"

// register 
export const register = async (req, res, next) => {
    try {
        const { username, email, password } = req.body
        if (!password || !username || !email) {
            return res.json({ message: "Missing informations" })
        }
        const user = await Admin.findOne({ email });
        if (user) {
            return res.json({ message: "User already exists" })
        }
        const admin = await Admin.create({
            username, email, password
        })
        return res.json({ message: 'Register Sucess', admin })
    } catch (error) {
        console.log(error);
        res.status(500).json({ error })
    }
}

// login
export const login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.json({ message: "Missing information" });
        }
        const user = await Admin.findOne({ email });
        if (!user) {
            return res.json({ message: "User doesnot exists" });
        }
        const isPasswordMatched = (user.password === password);
        if (!isPasswordMatched) {
            return res.json({ message: "User doesnot exist" });
        }
        // remaining to handle create session here 
        const token = user.createJWT();
        res.cookie('token', token, {
            httpOnly: true,
            secure: false,
            maxAge: 24 * 60 * 60 * 1000 // 1 day
        });

        return res.status(200).json({ message: "Login Success", token });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ error })
    }
}

// approve guide
export const approveGuide = async (req, res, next) => {
    try {
        if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
            return res.status(400).json({ message: "Invalid ID format" });
        }
        const id = new mongoose.Types.ObjectId(req.params.id);
        const guide = await Guide.findById(id);
        if (!guide) {
            return res.status(400).json({ message: "User doesnot exists" })
        }
        guide.isApproved = true;
        await guide.save();
        return res.status(200).json({ message: 'Guide Approved' });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ error })
    }

}
// reject guide
export const rejectGuide = async (req, res, next) => {
    try {
        if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
            return res.status(400).json({ message: "Invalid ID format" });
        }
        const id = new mongoose.Types.ObjectId(req.params.id);
        const guide = await Guide.findById(id);
        if (!guide) {
            return res.status(400).json({ message: "User doesnot exists" })
        }
        await Guide.deleteOne(id);
        return res.status(200).json({ message: 'Guide Rejected' })
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error });
    }
}

// logout
export const logout = async (req, res, next) => {
    try {
        // remove the existing cookies or session
        res.clearCookie('token')
        return res.status(200).json({ message: 'Logout Success' })
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error });
    }
}

// fetchDashboardInfo
export const fetchDashboardInfo = async (req, res, next) => {
    try {
        const pendingGuides = await Guide.find({ isApproved: false })
        const guideCount = await Guide.countDocuments()
        const touristCount = await Tourist.countDocuments()
        return res.status(200).json({
            guides: pendingGuides,
            guideCount,
            touristCount,
            totalCount: guideCount + touristCount
        })

    } catch (error) {
        console.log(error);
        return res.status(500).json({ error })
    }
}