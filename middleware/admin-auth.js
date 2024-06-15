import Admin from "../models/adminModel.js";

export const adminAuth = async(req,res,next) =>{
    try {
        const email = req.user.email;
        const adminExist = await Admin.findOne({email})

        if(!adminExist){
            return res.status(400).json({message:'Unauthorized Access1'})
        }
        next()
    } catch (error) {
        console.log(error)
        return res.status(500).json({error})
    }
}