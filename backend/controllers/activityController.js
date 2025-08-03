const express = require('express');
const Activity = require('../models/Activity');
const UserBadge = require('../models/UserBadge');
const Badge = require('../models/Badge');
const auth = require('../middleware/auth');
const router = express.Router();

// Log activity
router.post('/:type', auth, async (req, res) => {
  try {
    const { type } = req.params;
    const { value, mealDetails } = req.body;
    const userId = req.user.id;

    // Validate activity type
    const validTypes = ['steps', 'water', 'exercise', 'meal'];
    if (!validTypes.includes(type)) {
      return res.status(400).json({ message: 'Invalid activity type' });
    }

    // Validate value
    if (typeof value !== 'number' || value <= 0) {
      return res.status(400).json({ message: 'Value must be a positive number' });
    }

    // Create activity
    const activity = new Activity({
      userId,
      type,
      value,
      ...(type === 'meal' && { mealDetails })
    });
    await activity.save();

    // Update user points
    const user = req.user;
    user.points += 10;
    await user.save();

    // Check for badges
    const badges = await Badge.find({ 'criteria.activityType': type });
    for (const badge of badges) {
      const total = await Activity.aggregate([
        { $match: { userId: user._id, type } },
        { $group: { _id: null, total: { $sum: '$value' } } }
      ]);
      
      if (total.length > 0 && total[0].total >= badge.criteria.threshold) {
        const hasBadge = await UserBadge.findOne({ userId: user._id, badgeId: badge._id });
        if (!hasBadge) {
          const userBadge = new UserBadge({
            userId: user._id,
            badgeId: badge._id
          });
          await userBadge.save();
          
          // Add bonus points for earning badge
          user.points += 50;
          await user.save();
        }
      }
    }

    res.status(201).json(activity);
  } catch (error) {
    console.error('Activity logging error:', error);
    res.status(500).json({ message: 'Server error while logging activity' });
  }
});

// Get activities by type and date
router.get('/:type/:date', auth, async (req, res) => {
  try {
    const { type, date } = req.params;
    const userId = req.user.id;
    
    // Validate date
    const dateObj = new Date(date);
    if (isNaN(dateObj.getTime())) {
      return res.status(400).json({ message: 'Invalid date format' });
    }

    const activities = await Activity.find({
      userId,
      type,
      date: {
        $gte: new Date(dateObj.setHours(0, 0, 0, 0)),
        $lt: new Date(dateObj.setHours(23, 59, 59, 999))
      }
    });

    res.json(activities);
  } catch (error) {
    console.error('Get activities error:', error);
    res.status(500).json({ message: 'Server error while fetching activities' });
  }
});

module.exports = router;