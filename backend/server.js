const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const authRoutes = require('./routes/auth');
const goalRoutes = require('./routes/goals');
const badgeRoutes = require('./routes/badges');
const connectDB  = require('./config/db');

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());

connectDB();

app.use('/api/auth', authRoutes);
app.use('/api/goals', goalRoutes);
app.use('/api/badges', badgeRoutes);

const PORT = process.env.PORT;

app.listen(PORT, () => {
    console.log(`✅ Server started on port: ${PORT}`);
});
