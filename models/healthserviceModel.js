import mongoose from "mongoose";
import bcrypt from "bcryptjs"
import jwt from "jsonwebtoken";

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
        default: false
    },
    isAvailable: {
        type: Boolean,
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
            default:'Point'
        },        
        coordinates:{
            type: [Number],
            default:[0,0]
        }
    },
    regionalLocation: {
        type: String,
        required: true
    }
})

healthServiceSchema.index({ geoLocation: '2dsphere' })

healthServiceSchema.methods.createJWT = function () {
    return jwt.sign(
        { id: this._id, email: this.email, role: this.role },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_LIFETIME }
    )
}

healthServiceSchema.methods.matchPassword = async function (enteredPassword) {
    return await bcrypt.compare(enteredPassword, this.password);
}

const healthService = mongoose.model('healthService', healthServiceSchema);


export default healthService;