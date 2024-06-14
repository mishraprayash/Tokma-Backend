import healthService from "../models/healthserviceModel.js";

export const register = async (req, res, next) => {
  const {
    name,
    email,
    contactNo,
    profileImg,
    password,
    isApproved,
    isAvailabe,
    description,
    geoLocation,
    regionalLocation,
  } = req.body;
  if (
    !name ||
    !email ||
    !contactNo ||
    !profileImg ||
    !password ||
    !isApproved ||
    !isAvailabe ||
    !description ||
    !geoLocation ||
    !regionalLocation
  )
    return res.status(400).json({ message: "Missing informations" });

  try {
    console.log("hello");
    const health = await healthService.create({
      name,
      email,
      contactNo,
      profileImg,
      password,
      isApproved,
      isAvailabe,
      description,
      geoLocation,
      regionalLocation,
    });
    return res.status(201).json({ message: "Register Success", health });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

export const login = async (req, res, next) => {
  try {
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};
export const nearbyHealth = async (req, res, next) => {
  const { lat, lon } = req.body;
  let locations;
  try {
    locations = await healthService.find({
      geoLocation: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: [lon, lat],
          },
          $maxDistance: 1000,
        },
      },
    });
    return res.status(201).json({ message: "Results", locations });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};
