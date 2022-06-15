// Admin middleware

const jwt = require('jsonwebtoken');
const User = require('../models/user');

// Similar to auth middleware
const admin = async function (req, res, next) {
    try {
        // Get token
        const token = req.header('x-auth-token');

        // Check the token
        if (!token) {
            return res.status(401).json({message: 'No auth token, access denied'});
        }

        // Verify the token with jsonwebtoken
        const verified = jwt.verify(token, 'passwordKey');

        // Check verify
        if (!verified) {
            return res.status(401).json({message: 'Token verification failed, access denied'});
        }

        // Get and check user id
        const user = await User.findById(verified.id);
        
        // Check for user type other than admin
        if (user.type == 'user' || user.type == 'seller') {
            return res.status(401).json({message: 'You are not an admin, access denied'});
        }
        
        // All good, store it
        req.user = verified.id;
        req.token = token;
        next();

    } catch (e) {
        res.status(500).json({error: e.message});
    }
}

module.exports = admin;