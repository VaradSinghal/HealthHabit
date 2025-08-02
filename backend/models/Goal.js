const mongoose = require('mongoose');

const goalSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  date: { type: Date, default: Date.now },
  steps: { type: Number, default: 0 },
  water: { type: Number, default: 0 },
  activeBreaks: { type: Number, default: 0 },
  nutritiousMeals: { type: Number, default: 0 },
});

module.exports = mongoose.model('Goal', goalSchema);