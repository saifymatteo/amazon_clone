const express = require('express')
const admin = require('../middleware/admin')
const Order = require('../models/order')
const { Product } = require('../models/product')

const adminRouter = express.Router()

// Add product route
adminRouter.post('/admin/add-product', admin, async function (req, res) {
  try {
    const { name, description, images, quantity, price, category } = req.body

    let product = new Product({
      name, description, images, quantity, price, category
    })

    product = await product.save()

    res.json(product)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// Get admin products
adminRouter.get('/admin/get-products', admin, async function (req, res) {
  try {
    // Get all products
    const product = await Product.find({})

    // Send the products
    res.json(product)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// Delete product route
adminRouter.post('/admin/delete-product', admin, async function (req, res) {
  try {
    // Find product id
    const { id } = req.body

    // Delete it
    const product = await Product.findByIdAndDelete(id)

    // Send the json
    res.json(product)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// Get admin orders
adminRouter.get('/admin/get-orders', admin, async function (req, res) {
  try {
    const orders = await Order.find({})
    res.json(orders)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

adminRouter.post('/admin/change-order-status', admin, async function (req, res) {
  try {
    const { id, status } = req.body
    let order = await Order.findById(id)
    order.status = status
    order = await order.save()

    res.json(order)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

adminRouter.get('/admin/analytics', admin, async function (req, res) {
  try {
    const orders = await Order.find({})
    let totalEarning = 0

    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarning += orders[i].products[j].quantity * orders[i].products[j].product.price
      }
    }

    // Category Fetch Profit
    const mobileEarning = await fetchCategoryWiseProduct('Mobiles')
    const essentialsEarning = await fetchCategoryWiseProduct('Essentials')
    const appliancesEarning = await fetchCategoryWiseProduct('Appliances')
    const booksEarning = await fetchCategoryWiseProduct('Books')
    const fashionEarning = await fetchCategoryWiseProduct('Fashion')

    const earnings = {
      totalEarning,
      mobileEarning,
      essentialsEarning,
      appliancesEarning,
      booksEarning,
      fashionEarning
    }

    res.json(earnings)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

async function fetchCategoryWiseProduct (category) {
  let earnings = 0
  const categoryOrders = await Order.find({
    'products.product.category': category
  })

  for (let i = 0; i < categoryOrders.length; i++) {
    for (let j = 0; j < categoryOrders[i].products.length; j++) {
      earnings += categoryOrders[i].products[j].quantity * categoryOrders[i].products[j].product.price
    }
  }

  return earnings
}

module.exports = adminRouter
