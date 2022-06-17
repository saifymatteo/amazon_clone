const express = require('express')
const productRouter = express.Router()
const auth = require('../middleware/auth')
const { Product } = require('../models/product')

// Product category route
productRouter.get('/api/products', auth, async function (req, res) {
  try {
    // Get request query
    const category = req.query.category

    // Get product with the query
    const product = await Product.find({ category })

    // Send the product
    res.json(product)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// Product search route
productRouter.get('/api/products/search/:name', auth, async function (req, res) {
  try {
    // Get request param
    const search = req.params.name

    // Get product with the param by using RegEx
    const products = await Product.find({ name: { $regex: search, $options: 'i' } })

    // Send the product
    res.json(products)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// Product rating route
productRouter.post('/api/rate-product', auth, async function (req, res) {
  try {
    // Get the id and rating of request body
    const { id, rating } = req.body

    // Get the product with the id
    let product = await Product.findById(id)

    // Iterate through the ratings and find the existing rating from user
    for (let index = 0; index < product.ratings.length; index++) {
      if (product.ratings[index].userId === req.user) {
        product.ratings.splice(index, 1)
        break
      }
    }

    // Create the rating schema
    const ratingSchema = {
      userId: req.user,
      rating
    }

    // Add it to current product and save it
    product.ratings.push(ratingSchema)
    product = await product.save()

    // Send the product
    res.json(product)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

// Get best rating of product
productRouter.get('/api/deal-of-day', auth, async function (req, res) {
  try {
    let products = await Product.find({})

    products = products.sort((a, b) => {
      let aSum = 0
      let bSum = 0

      for (let index = 0; index < a.ratings.length; index++) {
        aSum += a.ratings[index].rating
      }

      for (let index = 0; index < b.ratings.length; index++) {
        bSum += a.ratings[index].rating
      }

      return aSum < bSum ? 1 : -1
    })

    res.json(products[0])
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

module.exports = productRouter
