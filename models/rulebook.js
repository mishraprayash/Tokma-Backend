import mongoose from "mongoose";
const ruleSchema = new mongoose.Schema({
    name:{
        type:String,
        required: true,

    },
    profile:{
        type:String,

    },
    rules:{
        type:[String],
    }
});
const rule = mongoose.model("Rule", ruleSchema);
export default rule;
