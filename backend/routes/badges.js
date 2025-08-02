const express = require('express');
const Badge = require('../models/Badge');
const authMiddleware = require('../middleware/auth');
const router = express.Router();


router.post('/', authMiddleware, async (req, res) => {
  const { name, description } = req.body;
  try {
    const badge = new Badge({
      userId: req.user.userId,
      name,
      description,
    });
    await badge.save();
    res.status(201).json(badge);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});


router.get('/', authMiddleware, async (req, res) => {
  try {
    const badges = await Badge.find({ userId: req.user.userId });
    res.json(badges);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;