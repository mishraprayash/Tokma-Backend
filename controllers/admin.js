import bcrypt from "bcryptjs"
import Admin from "../models/adminModel.js"
import Guide from "../models/guideModel.js"
import Tourist from "../models/touristModel.js"
import mongoose from "mongoose"
import healthService from "../models/healthserviceModel.js"
import rule from "../models/rulebook.js"
import foodAndLodging from "../models/foodandlodgingModel.js"

// register 
export const register = async (req, res, next) => {
    try {
        const { username, email, password } = req.body
        if (!password || !username || !email) {
            return res.status(400).json({ message: "Missing informations" })
        }
        const user = await Admin.findOne({ email });
        if (user) {
            return res.status(400).json({ message: "User already exists" })
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        const admin = await Admin.create({
            username, email,
            password: hashedPassword
        })
        return res.status(201).json({ message: 'Register Sucess', admin })
    } catch (error) {
        console.log(error);
        res.status(500).json({ error:error.message })
    }
}

// login
export const login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ message: "Missing information" });
        }
        const admin = await Admin.findOne({ email });
        if (!admin) {
            return res.status(400).json({ message: "User doesnot exists" });
        }
        const isPasswordMatched = await admin.matchPassword(password);

        if (!isPasswordMatched) {
            return res.status(400).json({ message: "User doesnot exist" });
        }
        // remaining to handle create session here 
        const token = admin.createJWT();
        return res.status(200).json({ message: "Login Success", token });

    } catch (error) {
        console.log(error);
        res.status(500).json({ error:error.message })

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
        res.status(500).json({ error:error.message })

    }

}
// reject guide
export const rejectGuide = async (req, res, next) => {
    try {
        const { id } = req.params;
        if (!mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({ message: "Invalid ID format" });
        }
        const guide = await Guide.findById(id);
        if (!guide) {
            return res.status(400).json({ message: "User does not exist" });
        }
        await Guide.deleteOne({ _id: id });
        return res.status(200).json({ message: 'Guide Rejected' });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error:error.message })

    }
};


// accept health service
export const approveHealthService = async (req, res, next) => {
    try {
        if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
            return res.status(400).json({ message: "Invalid ID format" });
        }
        const id = new mongoose.Types.ObjectId(req.params.id);
        const healthServ = await healthService.findById(id);
        if (!healthServ) {
            return res.status(400).json({ message: "Service doesnot exists" })
        }
        healthServ.isApproved = true
        await healthServ.save()
        return res.status(200).json({ message: 'Service Approved' })
    } catch (error) {
        console.log(error);
        res.status(500).json({ error:error.message })

    }
}

// reject health service
export const rejectHealthService = async (req, res, next) => {
    try {
        if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
            return res.status(400).json({ message: "Invalid ID format" });
        }
        const id = new mongoose.Types.ObjectId(req.params.id);
        const healthServ = await healthService.findById(id);
        if (!healthServ) {
            return res.status(400).json({ message: "User doesnot exists" })
        }
        await healthServ.deleteOne({ _id: id });
        return res.status(200).json({ message: 'Service Rejected' })
    } catch (error) {
        console.log(error);
        res.status(500).json({ error:error.message })

    }
}


export const approvefoodandlodge = async (req, res, next) => {
    try {
        if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
            return res.status(400).json({ message: "Invalid ID format" });
        }
        const id = new mongoose.Types.ObjectId(req.params.id);
        const foodandlodgeservice = await foodAndLodging.findById(id);
        if (!foodandlodgeservice) {
            return res.status(400).json({ message: "Service doesnot exists" })
        }
        foodandlodgeservice.isApproved = true
        await foodandlodgeservice.save()
        return res.status(200).json({ message: 'Service Approved' })
    } catch (error) {
        console.log(error);
        res.status(500).json({ error:error.message })

    }
}


export const rejectfoodandlodge = async (req, res, next) => {
    try {
        if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
            return res.status(400).json({ message: "Invalid ID format" });
        }
        const id = new mongoose.Types.ObjectId(req.params.id);
        const foodandlodgeservice = await foodAndLodging.findById(id);
        if (!foodandlodgeservice) {
            return res.status(400).json({ message: "Service doesnot exists" })
        }
        await foodandlodgeservice.deleteOne({ _id: id });
        return res.status(200).json({ message: 'Service Rejected' })
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error });
    }
}


// fetchDashboardInfo for admin
export const fetchDashboardInfo = async (req, res, next) => {
    try {
        const pendingGuides = await Guide.find({ isApproved: false }, { password: false })
        const guideCount = await Guide.countDocuments({ isApproved: true })
        const touristCount = await Tourist.countDocuments()
        const pendingHealthService = await healthService.find({ isApproved: false }, { password: false })
        const foodandlodgeService = await foodAndLodging.find({ isApproved: false }, { password: false })
        return res.status(200).json({
            guides: pendingGuides,
            healthService: pendingHealthService,
            foodandlodge: foodandlodgeService,
            guideCount,
            touristCount,
            totalCount: guideCount + touristCount
        })
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error })
    }
}
export const setRules = async (req, res, next) => {
    try {
        const { name, profile, rules } = req.body;
        if (!name || !profile || !rules) {
            return res.status(400).json({ message: "Missing informations" })
        }
        const createdRule = await rule.create({
            name, profile, rules
        })
        return res.status(200).json({ message: "success", createdRule })
    }
    catch (err) {
        return res.status(500).json({ err: err.message })
    }
}

