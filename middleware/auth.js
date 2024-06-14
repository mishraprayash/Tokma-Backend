import jwt from "jsonwebtoken";
import JsonWebTokenError from "jsonwebtoken/lib/JsonWebTokenError.js";

export const isAuthenticated = async (req, res, next) => {
    try {
        const token = req.cookies.token;
        if (!token) {
            return res.status(403).json({ message: "Unauthorized Access" });
        }
        const decodedToken = jwt.verify(token, process.env.JWT_SECRET)
        console.log(decodedToken);
        req.user = decodedToken
        next()
    } catch (error) {
        if(error instanceof JsonWebTokenError){
            return res.status(403).json({message:"Unauthorized Access"})
        }
        console.log(error);
        return res.status(500).json({ error });
    }
}