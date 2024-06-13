import mongoose from "mongoose";
import bcrypt from "bcryptjs";

const guideSchema = new mongoose.Schema({
    firstName: {
        type: String,
        required: true
    },
    lastName: {
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
    gender: {
        type: String,
        required: true,
        enum: ['Male', 'Female', 'Others']
    },
    age: {
        type: Number,
        required: true
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
    role: {
        type: String,
        default: 'guide'
    },
    hiringInfo: {
        isHired: {
            type: Boolean,
            default: false
        },
        hiringTourist: {
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'Tourist'
        }
    },
    isAvailable:{
        type:Boolean,
    }
})
guideSchema.methods.createJWT = function () {
    return jwt.sign(
        { id: this._id, email: this.email, role: this.role },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_LIFETIME }
    )
}

guideSchema.methods.matchPassword = async function(enteredPassword){
    return await bcrypt.compare(enteredPassword, this.password);
}
const Guide = mongoose.model('Guide', guideSchema);
export default Guide;