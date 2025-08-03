const mongoose = require('mongoose');

const badgeSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  icon: { type: String, required: true },
  criteria: {
    activityType: { type: String, required: true },
    threshold: { type: Number, required: true }
  }
});

module.exports = mongoose.model('Badge', badgeSchema);