// Import PACKAGE
const express = require('express');
const mongoose = require('mongoose');

// Import Files
const authRouter = require('./routes/auth.js');

// Set default PORT number
const PORT = 3000;

// MongoDB Url Path
const db = 'mongodb+srv://saifymatteo:TCfdc00zOdpcDvx5@cluster0.vtonx.mongodb.net/?retryWrites=true&w=majority';

// Initialize constant [app]
const app = express();

// Middleware
app.use(express.json());
app.use(authRouter);

// Connection
mongoose.connect(db)
    .then(function () {
        console.log('Connection successful');
    }).catch(function (e) {
        console.log(e);
    });

// Listen to server
app.listen(PORT, '0.0.0.0', function () {
    console.log(`Connected at port ${PORT}`);
});