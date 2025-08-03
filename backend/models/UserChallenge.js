const mongoose = require('mongoose');

const userChallengeSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  challengeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Challenge', required: true },
  progress: [{
    activityType: { type: String, required: true },
    current: { type: Number, default: 0 },
    target: { type: Number, required: true }
  }],
  completed: { type: Boolean, default: false },
  completedAt: { type: Date },
  joinedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('UserChallenge', userChallengeSchema);