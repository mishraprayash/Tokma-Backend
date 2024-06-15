
import Guide from "../models/guideModel.js"
import bcrypt from "bcryptjs"

export const register = async (req, res, next) => {
  const { firstName, lastName, contactNo, gender, age, location, email, password, description } = req.body;
  if (!firstName || !lastName || !contactNo || !gender || !age || !location || !email || !password || !description) {
    return res.status(400).json({ message: "Missing informations" })
  }
  const user = await Guide.findOne({ email })
  if (user) {
    return res.status(400).json({ message: "User already exists" })
  }
  const hashedPassword = await bcrypt.hash(password, 10)

  const guide = new Guide({
    firstName, lastName, contactNo, gender, age, email, password: hashedPassword, regionalLocation: location, description
  })
  await guide.save();
  return res.status(200).json({ message: "Register Success", guide })
};

export const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: "Missing information" })
    }
    const guide = await Guide.findOne({ email })
    if (!guide) {
      return res.status(400).json({ message: "User doesnot exists" })
    }
    const isPasswordMatched = await guide.matchPassword(password);
    if (!isPasswordMatched) {
      return res.status(400).json({ message: "User doesnot exist" })
    }
    // remaining to handle create session here
    const token = guide.createJWT();
    return res.status(200).json({ message: "Login Success", token })
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error })
  }
};

export const fetchDashboardInfo = async (req, res, next) => {
  try {
    const guide = await Guide.findOne({ _id: req.user.id }, { password: false });
    return res.status(200).json({ guide })
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error })
  }
};

export const fetchIndividualServiceFromTourist = async (req, res, next) => {
  try {
    const { id } = req.body
    const guide = await Guide.findOne({ _id: id }, { password: false });
    return res.status(200).json({ guide })
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: error.message })
  }
}

export const updateAvailability = async (req, res, next) => {
  try {
    const { lat, lon } = req.body
    console.log(req.user)
    const guide = await Guide.findOne({ email: req.user.email })
    const availableStatus = guide.isAvailable
    guide.isAvailable = !availableStatus
    guide.geoLocation.type = "Point"
    guide.geoLocation.coordinates = [lon, lat]
    await guide.save();
    console.log(guide)
    return res.status(200).json({ availability: `${guide.isAvailable}` })
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error })
  }
};
