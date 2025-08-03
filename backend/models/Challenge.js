const mongoose = require('mongoose');

const challengeSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  duration: { type: Number, required: true }, // in days
  criteria: [{
    activityType: { type: String, required: true },
    target: { type: Number, required: true }
  }],
  rewardPoints: { type: Number, required: true },
  startDate: { type: Date, default: Date.now },
  endDate: { type: Date },
  isActive: { type: Boolean, default: true }
});

// Calculate endDate based on duration
challengeSchema.pre('save', function(next) {
  if (this.isModified('duration') || this.isNew) {
    const endDate = new Date(this.startDate);
    endDate.setDate(endDate.getDate() + this.duration);
    this.endDate = endDate;
  }
  next();
});

module.exports = mongoose.model('Challenge', challengeSchema);