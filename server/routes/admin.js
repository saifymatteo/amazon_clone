const express = require('express');
const admin = require('../middleware/admin');
const Product = require('../models/product');
const User = require('../models/user');

const adminRouter = express.Router();

// Add product route
adminRouter.post('/admin/add-product', admin, async function (req, res) {
    try {
        const { name, description, images, quantity, price, category } = req.body;

        let product = new Product({
            name, description, images, quantity, price, category,
        });

        product = await product.save();

        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get admin products
adminRouter.get('/admin/get-products', admin, async function (req, res) {
    try {
        // Get all products
        const product = await Product.find({});

        // Send the products
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Delete product route
adminRouter.post('/admin/delete-product', admin, async function (req, res) {
    try {
        // Find product id
        const { id } = req.body;

        // Delete it
        let product = await Product.findByIdAndDelete(id);

        // Send the json
        res.json(product);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

module.exports = adminRouter;