// Import package
const express = require('express')
const User = require('../models/user')
const bcryptjs = require('bcryptjs')
const jwt = require('jsonwebtoken')
const auth = require('../middleware/auth')

// Initialize router
const authRouter = express.Router()

// Sign Up route
authRouter.post('/api/signup', async function (req, res) {
  // [Try] and [Catch] block for async function
  try {
    // Data from client side
    const { name, email, password } = req.body

    // Get existing user with email
    const existingUser = await User.findOne({ email })

    // If [existingUser] have any, return 400
    if (existingUser) {
      return res.status(400).json({ message: 'Email already used!' })
    }

    const hashedpassword = await bcryptjs.hash(password, 8)

    // Save new [User]
    let user = new User({ name, email, password: hashedpassword })
    user = await user.save()

    // Post User to database
    res.json(user)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// Sign In route
authRouter.post('/api/signin', async function (req, res) {
  // [Try] and [Catch] block for async function
  try {
    // Data from client side
    const { email, password } = req.body

    // Find existing [user]
    const user = await User.findOne({ email })

    // Check for no user
    if (!user) {
      return res.status(400).json({ message: 'Account email not exist' })
    }

    // Check sign in password
    const isMatch = await bcryptjs.compare(password, user.password)

    // If isMatch not true, return error
    if (!isMatch) {
      return res.status(400).json({ message: 'Incorrect password.' })
    }

    // Create token
    const token = jwt.sign({ id: user._id }, 'passwordKey')

    // Send it
    res.json({ token, ...user._doc })
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// Verify token route
authRouter.post('/api/tokenIsValid', async function (req, res) {
  try {
    // Get token authentication
    const token = req.header('x-auth-token')

    // Check the token
    if (!token) {
      return res.json(false)
    }

    // Verify the token
    const verified = jwt.verify(token, 'passwordKey')

    // Check the token
    if (!verified) {
      return res.json(false)
    }

    // Find the user with the Id token
    const user = await User.findById(verified.id)

    // Check the user
    if (!user) {
      return res.json(false)
    }

    // If all check false, return true
    res.json(true)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// Get user data
authRouter.get('/', auth, async function (req, res) {
  const user = await User.findById(req.user)
  res.json({ ...user._doc, token: req.token })
})

// Export to let index.js use
module.exports = authRouter
