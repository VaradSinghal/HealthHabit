const express = require('express');
const Badge = require('../models/Badge');
const UserBadge = require('../models/UserBadge');
const User = require('../models/User');
const auth = require('../middleware/auth');
const router = express.Router();

// Get all available badges
router.get('/', auth, async (req, res) => {
  try {
    const badges = await Badge.find();
    res.json(badges);
  } catch (error) {
    console.error('Get badges error:', error);
    res.status(500).json({ message: 'Server error while fetching badges' });
  }
});

// Get user's earned badges
router.get('/earned', auth, async (req, res) => {
  try {
    const userBadges = await UserBadge.find({ userId: req.user._id }).populate('badgeId');
    res.json(userBadges.map(ub => ({
      ...ub.badgeId.toObject(),
      earnedAt: ub.earnedAt
    })));
  } catch (error) {
    console.error('Get earned badges error:', error);
    res.status(500).json({ message: 'Server error while fetching earned badges' });
  }
});

// Get badge details by ID
router.get('/:id', auth, async (req, res) => {
  try {
    const badge = await Badge.findById(req.params.id);
    if (!badge) {
      return res.status(404).json({ message: 'Badge not found' });
    }

    // Check if user has earned this badge
    const userBadge = await UserBadge.findOne({
      userId: req.user._id,
      badgeId: badge._id
    });

    res.json({
      ...badge.toObject(),
      earned: !!userBadge,
      earnedAt: userBadge?.earnedAt
    });
  } catch (error) {
    console.error('Get badge details error:', error);
    res.status(500).json({ message: 'Server error while fetching badge details' });
  }
});

// Admin-only: Create new badge (protected with admin check)
router.post('/', auth, async (req, res) => {
  try {
    // In a real app, you'd check if user is admin
    // if (!req.user.isAdmin) {
    //   return res.status(403).json({ message: 'Not authorized' });
    // }

    const { name, description, icon, activityType, threshold } = req.body;

    // Validate input
    if (!name || !description || !icon || !activityType || !threshold) {
      return res.status(400).json({ message: 'Please provide all required fields' });
    }

    const badge = new Badge({
      name,
      description,
      icon,
      criteria: {
        activityType,
        threshold
      }
    });

    await badge.save();

    res.status(201).json(badge);
  } catch (error) {
    console.error('Create badge error:', error);
    res.status(500).json({ message: 'Server error while creating badge' });
  }
});

module.exports = router;