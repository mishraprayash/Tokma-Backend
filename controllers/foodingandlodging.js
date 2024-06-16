import foodAndLodging from "../models/foodandlodgingModel.js"
import bcrypt from "bcryptjs"

export const register = async (req, res, next) => {
  try {
    const {
      name,
      email,
      contactNo,
      country,
      description,
      password,
      lat,
      lon,
      profileImg
    } = req.body;
    if (
      !name ||
      !email ||
      !contactNo ||
      !country ||
      !description ||
      !password ||
      !lat ||
      !lon
    ) {
      return res.status(400).json({ message: "Missing informations" });
    }
    const user = await foodAndLodging.findOne({ email });
    if (user) {
      return res.status(400).json({ message: "User already exists" });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const foodandlodging = await foodAndLodging.create({
      name,
      email,
      contactNo,
      country,
      description,
      password: hashedPassword,
      profileImg
    });
    foodandlodging.geoLocation.type = "Point"
    foodandlodging.geoLocation.coordinates = [lon, lat]
    await foodandlodging.save()
    return res.status(200).json({ message: "Registered Successfully" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

export const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: "Missing informations" });
    }
    const foodandlodging = await foodAndLodging.findOne({ email });
    if (!email) {
      return res.status(400).json({ message: "User doesnot exist" });
    }
    const isPasswordMatch = await foodandlodging.matchPassword(password);
    if (!isPasswordMatch) {
      return res.status(400).json({ message: "User doesnot exist" });
    }
    const token = foodandlodging.createJWT();

    return res.status(200).json({ message: "Login Success", token });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

export const fetchDashboardInfo = async (req, res, next) => {
  try {
    const guide = await foodAndLodging.findById(
      { _id: req.user.id },
      { password: false }
    );
    return res.status(200).json({ guide })
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error })
  }
};

export const updateAvailability = async (req, res, next) => {
  try {
    const foodAndLodgeService = await foodAndLodging.findById({ _id: req.user.id })
    const availableStatus = foodAndLodgeService.isAvailable
    foodAndLodgeService.isAvailable = !availableStatus
    await foodAndLodgeService.save()
    return res.status(200).json({ availability: `${foodAndLodgeService.isAvailable}` })
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error })
  }
}

// tourist will call this api
export const fetchIndividualServiceFromTourist = async (req, res, next) => {
  try {
    const { id } = req.body
    const foodandlodging = await foodAndLodging.findOne({ _id: id }, { password: false })
    if (!foodandlodging) {
      return res.status(400).json({ message: "Service doesnot exists" })
    }
    return res.status(200).json({ foodandlodging })
  } catch (error) {
    console.log(error)
    return res.status(500).json({ error: error.message })
  }
}