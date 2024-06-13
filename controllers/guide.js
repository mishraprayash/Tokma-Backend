import mongoose from "mongoose"
import Guide from "../models/guideModel.js"
import bcrypt from "bcryptjs"
import Tourist from "../models/touristModel.js";

export const register = async (req, res, next) => {
    const { name, contactNo, gender, age, location, email, password } = req.body;
    if (!name || !contactNo || !gender || !age || !location) {
        return res.json({ message: "Missing informations" });
    }
    const user = await Guide.findOne({ email });
    if (user) {
        return res.json({ message: "User already exists" })
    }
    const hashedPassword = await bcrypt.hash(password, 10);

    const guide = await Guide.create({
        name, contactNo, gender, age, location, email,
        password: hashedPassword
    })
    return res.json({ message: "Register Success", guide });
}

export const login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.json({ message: "Missing information" });
        }
        const guide = await Guide.findOne({ email });
        if (!guide) {
            return res.json({ message: "User doesnot exists" });
        }
        const isPasswordMatched = await guide.matchPassoword(password);
        if (!isPasswordMatched) {
            return res.json({ message: "User doesnot exist" });
        }
        // remaining to handle create session here 
        const token = guide.createJWT();
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


export const fetchDashboardInfo = async (req, res, next) => {
    try {
        const guide = await Guide.findById(req.user.id)
        
        
    } catch (error) {

    }
}




// accept the hire request from the tourist
// export const acceptOffer = async (req, res, next) => {
//     try {
//         if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
//             return res.status(404).json({ message: "Invalid ID Format" })
//         }
//         // this is the guide id
//         const guide = await Guide.findById(req.user.id)

//         // this is the id of the tourist who have request to hire the guide
//         const id = new mongoose.Types.ObjectId(req.params.id)

//         // ensuring if the tourist exist
//         const touristExist = await Tourist.findById(id)
//         if (!touristExist) {
//             return res.status(404).json({ message: "Tourist doesnot exist" })
//         }
//         // changing guide status
//         guide.hiringInfo.isHired = true
//         // adding tourist info to guide hiringInfo
//         guide.hiringInfo.hiringTourist = id

//         // updating tourist model for hiring process
//         touristExist.guideRequests.status = 'hired'
//         touristExist.guideRequests.hiredGuide = guide._id
//         await guide.save()
//         await touristExist.save()

//         return res.status(200).json({ message: "Accepted Offer" })

//     } catch (error) {
//         console.log(error);
//         return res.status(500).json({ error })
//     }
// }


