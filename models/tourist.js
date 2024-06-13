import mongoose from "mongoose"
import bcrypt from "bcryptjs"
import jwt from "jsonwebtoken"

const emergencyContactInfoSchema = new mongoose.Schema({
    phoneNo: {
        type: Number
    },
    email: {
        type: String,
    }
}, { _id: false })

const touristSchema = new mongoose.Schema({
    firstName: {
        type: String,
        required: true
    },
    lastName: {
        type: String,
        required: true
    },
    contactNo: {
        type: String,
        maxLength: 10,
        required: true
    },
    country: {
        type: String,
        required: true
    },
    gender: {
        type: String,
        required: true,
        enum: ['Male', 'Female', 'Others']
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    age: {
        type: Number,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    guideRequests: [{
        hasHired: {
            type: Boolean,
            default: false
        },
        hiredGuide: {
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'Guide'
        }
    }],
    emergencyContactInfoSchema
})


touristSchema.methods.createJWT = function () {
    return jwt.sign(
        { id: this._id, email: this.email, role: this.role },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_LIFETIME }
    )
}

touristSchema.methods.matchPassword = async function (enteredPassword) {
    return await bcrypt.compare(enteredPassword, this.password);
}

const Tourist = mongoose.model('Tourist', touristSchema);
export default Tourist;