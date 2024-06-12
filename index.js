import express from "express"
import connectDB from "./config/dbconfig.js"
import {config} from "dotenv"

import guideRoutes from "./routes/guideRoutes.js"
import adminRoutes from "./routes/adminRoutes.js"
import touristRoutes from "./routes/adminRoutes.js"

config();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/guide',guideRoutes);
app.use('/api/admin',adminRoutes);
app.use('/api/tourist',touristRoutes);

const PORT = process.env.PORT || 3001



app.get('/',(req,res)=>{
    return res.json({message:"Server is working..."})
})

const startServer = async () => {
    try {
        await connectDB()
        console.log('DB Connected');
        app.listen(PORT, (req, res) => {
            console.log(`Server listening on port ${PORT}.....`);
        })
    } catch (error) {
        console.log(`Error occured:- ${error}`);
    }
}
startServer()