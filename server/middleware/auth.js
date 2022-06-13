// Auth middleware

const jwt = require('jsonwebtoken');

const auth = async function (req, res, next) {
    // Try and catch block
    try {
        // Get token
        const token = req.header('x-auth-token');

        // Check token
        if (!token) {
            return res.status(401).json({message: 'No auth token, access denied'});
        }

        // Verify token with jsonwebtoken
        const verified = jwt.verify(token, 'passwordKey');

        // Check verify
        if (!verified) {
            return res.status(401).json({message: 'Token verification failed, access denied'});
        }

        // All good, store it
        req.user = verified.id;
        req.token = token;
        next();

    } catch (e) {
        res.status(500).json({error: e.message});
    }
}

module.exports = auth;