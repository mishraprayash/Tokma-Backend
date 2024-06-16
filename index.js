import express from "express"
import connectDB from "./config/dbconfig.js"
import { config } from "dotenv"
import cors from "cors"
import cookieParser from "cookie-parser"

import guideRoutes from "./routes/guideRoutes.js"
import adminRoutes from "./routes/adminRoutes.js"
import touristRoutes from "./routes/touristRoutes.js"
import healthServiceRoutes from "./routes/healthServiceRoutes.js"
import foodandlodgingRoutes from "./routes/foodandlodgingroute.js"
import notFoundMiddleware from "./middleware/not-found.js"


// dotenv configuration
config();

// create an instance of express app
const app = express();

// middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser())
app.use(cors({
    // credentials: true,
    // origin: '*'
}))

// routes
app.use('/api/guide', guideRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/tourist', touristRoutes);
app.use('/api/healthservice', healthServiceRoutes)
app.use('/api/foodandlodge',foodandlodgingRoutes)

const PORT = process.env.PORT || 3001


app.get('/', (req, res) => {
    return res.json({ message: "Server is working..." })
})

app.use(notFoundMiddleware);

const startServer = async () => {
    try {
        await connectDB()
        app.listen(PORT, (req, res) => {
            console.log(`Server listening on port ${PORT}.....`);
        })
    } catch (error) {
        console.log(`Error occured:- ${error}`);
    }
}

// start the server
startServer()
