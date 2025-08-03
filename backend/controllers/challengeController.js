const express = require('express');
const Challenge = require('../models/Challenge');
const UserChallenge = require('../models/UserChallenge');
const Activity = require('../models/Activity');
const auth = require('../middleware/auth');
const router = express.Router();

// Get all active challenges
router.get('/', auth, async (req, res) => {
  try {
    const challenges = await Challenge.find({ isActive: true });
    
    // For each challenge, add user's participation status
    const challengesWithStatus = await Promise.all(challenges.map(async challenge => {
      const userChallenge = await UserChallenge.findOne({
        userId: req.user._id,
        challengeId: challenge._id
      });
      
      return {
        ...challenge.toObject(),
        joined: !!userChallenge,
        completed: userChallenge?.completed || false
      };
    }));

    res.json(challengesWithStatus);
  } catch (error) {
    console.error('Get challenges error:', error);
    res.status(500).json({ message: 'Server error while fetching challenges' });
  }
});

// Get challenge details by ID
router.get('/:id', auth, async (req, res) => {
  try {
    const challenge = await Challenge.findById(req.params.id);
    if (!challenge) {
      return res.status(404).json({ message: 'Challenge not found' });
    }

    const userChallenge = await UserChallenge.findOne({
      userId: req.user._id,
      challengeId: challenge._id
    }).populate('challengeId');

    // Calculate progress if user has joined
    let progress = null;
    if (userChallenge) {
      progress = await Promise.all(userChallenge.progress.map(async p => {
        const total = await Activity.aggregate([
          { 
            $match: { 
              userId: req.user._id,
              type: p.activityType,
              date: { $gte: userChallenge.joinedAt }
            }
          },
          { $group: { _id: null, total: { $sum: '$value' } } }
        ]);
        
        return {
          activityType: p.activityType,
          current: total[0]?.total || 0,
          target: p.target,
          percentage: Math.min(Math.round(((total[0]?.total || 0) / p.target * 100), 100))
        };
      }));
    }

    res.json({
      ...challenge.toObject(),
      joined: !!userChallenge,
      completed: userChallenge?.completed || false,
      progress
    });
  } catch (error) {
    console.error('Get challenge details error:', error);
    res.status(500).json({ message: 'Server error while fetching challenge details' });
  }
});

// Join a challenge
router.post('/:id/join', auth, async (req, res) => {
  try {
    const challenge = await Challenge.findById(req.params.id);
    if (!challenge) {
      return res.status(404).json({ message: 'Challenge not found' });
    }

    if (!challenge.isActive) {
      return res.status(400).json({ message: 'Challenge is not active' });
    }

    // Check if user already joined
    const existingUserChallenge = await UserChallenge.findOne({ 
      userId: req.user._id,
      challengeId: challenge._id
    });

    if (existingUserChallenge) {
      return res.status(400).json({ message: 'Already joined this challenge' });
    }

    // Create user challenge record
    const userChallenge = new UserChallenge({
      userId: req.user._id,
      challengeId: challenge._id,
      progress: challenge.criteria.map(c => ({
        activityType: c.activityType,
        current: 0,
        target: c.target
      }))
    });

    await userChallenge.save();

    res.status(201).json({
      message: 'Successfully joined challenge',
      challenge: {
        ...challenge.toObject(),
        joined: true,
        completed: false
      }
    });
  } catch (error) {
    console.error('Join challenge error:', error);
    res.status(500).json({ message: 'Server error while joining challenge' });
  }
});

// Update challenge progress (called when user logs activities)
router.post('/:id/progress', auth, async (req, res) => {
  try {
    const userChallenge = await UserChallenge.findOne({
      userId: req.user._id,
      challengeId: req.params.id
    }).populate('challengeId');

    if (!userChallenge) {
      return res.status(404).json({ message: 'Challenge not found or not joined' });
    }

    if (userChallenge.completed) {
      return res.status(400).json({ message: 'Challenge already completed' });
    }

    // Check if challenge is expired
    if (new Date() > userChallenge.challengeId.endDate) {
      return res.status(400).json({ message: 'Challenge has expired' });
    }

    // In a real app, you would update progress based on the activity type
    // For this example, we'll just return the current progress

    // Calculate current progress
    const progress = await Promise.all(userChallenge.progress.map(async p => {
      const total = await Activity.aggregate([
        { 
          $match: { 
            userId: req.user._id,
            type: p.activityType,
            date: { $gte: userChallenge.joinedAt }
          }
        },
        { $group: { _id: null, total: { $sum: '$value' } } }
      ]);
      
      return {
        activityType: p.activityType,
        current: total[0]?.total || 0,
        target: p.target,
        percentage: Math.min(Math.round(((total[0]?.total || 0) / p.target * 100), 100))
      };
    }));

    // Check if all criteria are met
    const isCompleted = progress.every(p => p.percentage >= 100);

    if (isCompleted) {
      userChallenge.completed = true;
      userChallenge.completedAt = new Date();
      await userChallenge.save();

      // Award points
      const user = req.user;
      user.points += userChallenge.challengeId.rewardPoints;
      await user.save();
    }

    res.json({
      progress,
      completed: isCompleted,
      pointsEarned: isCompleted ? userChallenge.challengeId.rewardPoints : 0
    });
  } catch (error) {
    console.error('Update challenge progress error:', error);
    res.status(500).json({ message: 'Server error while updating challenge progress' });
  }
});

// Admin-only: Create new challenge
router.post('/', auth, async (req, res) => {
  try {
    // In a real app, you'd check if user is admin
    // if (!req.user.isAdmin) {
    //   return res.status(403).json({ message: 'Not authorized' });
    // }

    const { name, description, duration, criteria, rewardPoints } = req.body;

    // Validate input
    if (!name || !description || !duration || !criteria || !rewardPoints) {
      return res.status(400).json({ message: 'Please provide all required fields' });
    }

    if (!Array.isArray(criteria) || criteria.length === 0) {
      return res.status(400).json({ message: 'Challenge must have at least one criteria' });
    }

    const challenge = new Challenge({
      name,
      description,
      duration,
      criteria,
      rewardPoints,
      isActive: true
    });

    await challenge.save();

    res.status(201).json(challenge);
  } catch (error) {
    console.error('Create challenge error:', error);
    res.status(500).json({ message: 'Server error while creating challenge' });
  }
});

module.exports = router;