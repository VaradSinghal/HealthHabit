const mongoose = require('mongoose');

const activitySchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  type: { type: String, enum: ['steps', 'water', 'exercise', 'meal'], required: true },
  value: { type: Number, required: true },
  mealDetails: {
    name: String,
    calories: Number,
    nutrients: {
      protein: Number,
      carbs: Number,
      fat: Number
    }
  },
  date: { type: Date, default: Date.now },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Activity', activitySchema);