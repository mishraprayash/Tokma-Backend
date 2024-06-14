import mongoose from "mongoose";
import { type } from "os";

const healthServiceSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    contactNo: {
        type: String,
        maxLength: 10,
        required: true
    },
    profileImg: {
        type: String
    },
    password: {
        type: String,
        required: true
    },
    isApproved: {
        type: Boolean,
        required: true,
        default: false
    },
    isAvailable: {
        type: String,
        required: true,
        default: false
    },
    description: {
        type: String,
        required: true
    },
    geoLocation: {
        type: {
            type: String,
            enum: ["Point"],
            required: true
        },        
        coordinates:{
            type: [Number],
            required: true
        }
    },
    regionalLocation: {
        type: String,
        required: true
    }
})

healthServiceSchema.methods.createJWT = function () {
    return jwt.sign(
        { id: this._id, email: this.email, role: this.role },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_LIFETIME }
    )
}

healthServiceSchema.methods.matchPassword = async function(enteredPassword){
    return await bcrypt.compare(enteredPassword, this.password);
}

const healthService = mongoose.model('healthService', healthServiceSchema);
export default healthService;