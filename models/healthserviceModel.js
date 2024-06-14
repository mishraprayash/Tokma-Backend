import mongoose from "mongoose";

const healthServiceSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  contactNo: {
    type: String,
    maxLength: 10,
    required: true,
  },
  profileImg: {
    type: String,
  },
  password: {
    type: String,
    required: true,
  },
  isApproved: {
    type: Boolean,
    required: true,
    default: false,
  },
  isAvailabe: {
    type: Boolean,
    required: true,
    default: false,
  },
  description: {
    type: String,
    required: true,
  },
  geoLocation: {
    type: {
      type: String,
      enum: ["Point"],
      required: true,
    },
    coordinates: {
      type: [Number],
      required: true,
    },
  },
  regionalLocation: {
    type: String,
    required: true,
  },
});
healthServiceSchema.index({ geoLocation: "2dsphere" });

const healthService = mongoose.model("healthService", healthServiceSchema);
export default healthService;
