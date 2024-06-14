import mongoose from "mongoose";

export default async function connectDB() {
    try {
        if (!process.env.DATABASE_REMOTE) {
            throw new Error('Database connection string is not provided.');
        }
        await mongoose.connect(process.env.DATABASE_REMOTE, {
            dbName:'Hackathon',
            connectTimeoutMS:20000
        }, );

        mongoose.connection.on('connected',(err)=>{
            console.log('DB Connected');
        })
        mongoose.connection.on('error', (err) => {
            console.error('MongoDB connection error:', err);
        });

        mongoose.connection.on('disconnected', () => {
            console.log('MongoDB disconnected');
        });
    } catch (error) {
        console.error('MongoDB Error', error);
    }
}
