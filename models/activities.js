import mongoose from "mongoose";
const activitivesSchema = new mongoose.Schema({
    name:{
        type:String,
        required: true,

    },
    geoLocation: {
        type: {
            type: String,
            enum: ["Point"],
        },
        coordinates: {
            type: [Number],
        }
    },
    regionalLocation: {
        type: String,
        required: true
    },

});
const rule = mongoose.model("Rule", ruleSchema);
export default rule;
