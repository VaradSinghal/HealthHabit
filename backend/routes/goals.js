const express = require('express');
const Goal = require('../models/Goal');
const authMiddleware = require('../middleware/auth');
const router = express.Router();


router.post('/', authMiddleware, async (req, res) => {
  const { steps, water, activeBreaks, nutritiousMeals } = req.body;
  try {
    const today = new Date().setHours(0, 0, 0, 0);
    let goal = await Goal.findOne({ userId: req.user.userId, date: { $gte: today } });

    if (goal) {
      goal.steps = steps ?? goal.steps;
      goal.water = water ?? goal.water;
      goal.activeBreaks = activeBreaks ?? goal.activeBreaks;
      goal.nutritiousMeals = nutritiousMeals ?? goal.nutritiousMeals;
      await goal.save();
    } else {
      goal = new Goal({
        userId: req.user.userId,
        steps,
        water,
        activeBreaks,
        nutritiousMeals,
      });
      await goal.save();
    }
    res.json(goal);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

router.get('/', authMiddleware, async (req, res) => {
  try {
    const today = new Date().setHours(0, 0, 0, 0);
    const goal = await Goal.findOne({ userId: req.user.userId, date: { $gte: today } });
    res.json(goal || {});
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;