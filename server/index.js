// Import PACKAGE
const express = require('express')
const mongoose = require('mongoose')
require('dotenv').config()

// Import Files
const adminRouter = require('./routes/admin.js')
const authRouter = require('./routes/auth.js')
const productRouter = require('./routes/product.js')
const userRouter = require('./routes/user.js')

// Set default PORT number
const PORT = 3000

// MongoDB Url Path
const db = `mongodb+srv://${process.env.USER_NAME}:${process.env.USER_PASS}@cluster0.vtonx.mongodb.net/?retryWrites=true&w=majority`

// Initialize constant [app]
const app = express()

// Middleware
app.use(express.json())
app.use(authRouter)
app.use(adminRouter)
app.use(productRouter)
app.use(userRouter)

// Connection
mongoose.connect(db)
  .then(function () {
    console.log('Connection successful')
  }).catch(function (e) {
    console.log(e)
  })

// Listen to server
app.listen(PORT, '0.0.0.0', function () {
  console.log(`Connected at port ${PORT}`)
})
