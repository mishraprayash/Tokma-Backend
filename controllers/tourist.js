import Tourist from "../models/touristModel.js";

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
      !phoneNo
    ) {
      return res.json({ message: "Missing informations" });
    }
    const user = await Guide.findOne({ email });
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
    });
    return res.json({ msg: "Successfully created", tourist });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

export const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.json({ message: "Missing informations" });
    }

    return res.json({});
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};
