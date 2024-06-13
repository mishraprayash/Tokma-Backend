import mongoose from "mongoose";

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
    emergencyContactInfoSchema
})

const Tourist = mongoose.model('Tourist', touristSchema);
export default Tourist;