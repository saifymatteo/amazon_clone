// Import package
const e = require('express');
const express = require('express');
const User = require('../models/user');
const bcryptjs = require('bcryptjs');

// Initialize router
const authRouter = express.Router();

authRouter.post('/api/signup', async function (req, res) {
    try {
        // Data from client side
        const { name, email, password } = req.body;

        // Get existing user with email
        const existingUser = await User.findOne({ email });

        // If [existingUser] have any, return 400
        if (existingUser) {
            return res.status(400).json({ message: 'Email already used!' });
        }

        const hashedpassword = await bcryptjs.hash(password, 8);

        // Save new [User]
        let user = new User({ name, email, password: hashedpassword });
        user = await user.save();

        // Post User to database
        res.json(user);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

// Export to let index.js use
module.exports = authRouter;