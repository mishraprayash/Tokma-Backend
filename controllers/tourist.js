import Tourist from "../models/touristModel.js";
import bcrypt from "bcryptjs";
import healthService from "../models/healthserviceModel.js";
import Guide from "../models/guideModel.js";
import rule from "../models/rulebook.js";
import foodAndLodging from "../models/foodandlodgingModel.js";
export const register = async (req, res, next) => {
  try {
    const {
      firstName,
      lastName,
      contactNo,
      country,
      gender,
      email,
      age,
      password,
      emergencyEmail,
      emergencyNumber,
    } = req.body;
    if (
      !firstName ||
      !lastName ||
      !contactNo ||
      !country ||
      !gender ||
      !email ||
      !age ||
      !password ||
      !emergencyEmail ||
      !emergencyNumber
    ) {
      return res.status(400).json({ message: "Missing informations" });
    }
    const user = await Tourist.findOne({ email });
    if (user) {
      return res.status(400).json({ message: "User already exists" });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const tourist = await Tourist.create({
      firstName,
      lastName,
      contactNo,
      country,
      gender,
      email,
      age,
      password: hashedPassword,
      emergencyEmail,
      emergencyNumber,
    });
    return res.status(200).json({ messageg: "Registered Successfully" });
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
    const tourist = await Tourist.findOne({ email });
    if (!email) {
      return res.status(400).json({ message: "User doesnot exist" });
    }
    const isPasswordMatch = await tourist.matchPassword(password);
    if (!isPasswordMatch) {
      return res.status(400).json({ message: "User doesnot exist" });
    }
    const token = tourist.createJWT();
    return res.status(200).json({ message: "Login Success", token });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

export const nearbyHealthServices = async (req, res, next) => {
  try {
    const email = req.user.email;
    const touristDetails = await Tourist.findOne({ email });
    const locat = touristDetails.geoLocation;
    console.log(locat);
    const locations = await healthService.find({
      geoLocation: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: locat.coordinates,
          },
          $maxDistance: 10000000, //1000 m =1km
        },
      },
      //  isApproved: true, isAvailable: true
    });
    return res.status(200).json({ message: "Results", locations });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

export const nearbyLocalGuides = async (req, res, next) => {
  try {
    const email = req.user.email;
    const touristDetails = await Tourist.findOne({ email });
    const locat = touristDetails.geoLocation;

    const nearbyGuides = await Guide.find({
      geoLocation: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: locat.coordinates,
          },
          $maxDistance: 10000000, //1000 m =1km
        },
      },
      // isApproved: true, isAvailable: true 
    });
    return res.status(200).json({ message: "Results", nearbyGuides });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

export const nearbyFoodandLodge = async (req, res, next) => {
  try {
    const email = req.user.email;
    const touristDetails = await Tourist.findOne({ email });
    const locat = touristDetails.geoLocation;

    const nearbyfoodandlodge = await foodAndLodging.find({
      geoLocation: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: locat.coordinates,
          },
          $maxDistance: 10000000, //1000 m =1km
        },
      },
    })
    return res.status(200).json({ message: "Results", nearbyfoodandlodge });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
}

export const touristInfo = async (req, res, next) => {
  try {
    const email = req.user.email;
    const touristDetails = await Tourist.findOne(
      { email },
      { password: false }
    );
    res.status(200).json({ touristDetails });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

export const updateLocation = async (req, res, next) => {
  const { lat, lon } = req.body;
  try {
    const touristDetails = await Tourist.findOne({ email: req.user.email })

    touristDetails.geoLocation.type = "Point"
    touristDetails.geoLocation.coordinates = [lon, lat];
    await touristDetails.save();

    res.status(201).json({ messege: "Location Updated" });
  } catch (error) {
    res.status(400).json({ error });
  }
};

export const fetchAllService = async (req, res, next) => {
  try {
    const touristDetails = await Tourist.findOne({ email: req.user.email })
    console.log(touristDetails)
    const touristLocation = touristDetails.geoLocation;
    console.log(touristLocation);
    const nearbyGuides = await Guide.find({
      geoLocation: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: touristLocation.coordinates,
          },
          $maxDistance: 10000000, //1000 m =1km
        },
      },
      // isApproved: true, isAvailable: true
    },).limit(3);
    const nearbyHealthService = await healthService.find({
      geoLocation: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: touristLocation.coordinates,
          },
          $maxDistance: 10000000, //1000 m =1km
        },
      },
      // isApproved: true, isAvailable: true
    }).limit(3)

    const nearbyFoodandLodge = await foodAndLodging.find({
      geoLocation: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: touristLocation.coordinates,
          },
          $maxDistance: 10000000, //1000 m =1km
        },
      },
    }).limit(3)
    return res.status(200).json({
      nearbyGuides, nearbyHealthService, 
      nearbyFoodandLodge
    })
  } catch (error) {
    res.status(400).json({ error:error.message });
  }
}
export const fetchRules = async (req, res, next) => {
  try {
    const { name } = req.body;
    if (!name) {
      return res.status(400).json({ message: "No name provided" })
    }
    const ruleFetch = await rule.find({ name: new RegExp(`^${name}`, 'i') });
    res.status(200).json({ message: "success", data: ruleFetch });
  }
  catch (error) {
    res.status(400).json({ error });
  }
}