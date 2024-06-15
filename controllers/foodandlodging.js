import foodAndLodging from "../models/foodandlodgingModel.js";
export const register = async (req, res, next) => {
  try {
    const {
      name,
      email,
      contactNo,
      country,
      description,
      password,
    } = req.body;
    if (
        !name||
        !email||
        !contactNo||
        !country||
        !description||
        !password
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
    });
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

    res.cookie("token", token, {
      httpOnly: true,
      maxAge: 24 * 60 * 60 * 100,
    });
    return res.status(200).json({ message: "Login Success", token });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

export const fetchDashboardInfo = async (req, res, next) => {
    try {
      const guide = await foodAndLodging.findById(
        { id: req.user.id },
        { password: false }
      );
      return res.status(200).json({ guide })
    } catch (error) {
      console.log(error);
      return res.status(500).json({ error })
    }
  };