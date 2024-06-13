import mongoose from "mongoose";
import { type } from "os";

const guideSchema = new mongoose.Schema({
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
    profileImg:{
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
    isAvailabe:{
        type: String,
        required: true
    },
    description: {
        type: String,
        required: true
    },
    geoLocation:{
        type: String,
        required: true
    },
    regionalLocation:{
        type: String,
        required: true
    }
})


const Guide = mongoose.model('Guide', guideSchema);
export default Guide;