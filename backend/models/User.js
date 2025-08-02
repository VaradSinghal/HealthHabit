const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  profile: {
    age: Number,
    fitnessGoals: String,
    dietaryPreferences: String,
  },
});

module.exports = mongoose.model('User', userSchema);