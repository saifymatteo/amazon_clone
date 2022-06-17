const express = require('express')
const auth = require('../middleware/auth')
const { Product } = require('../models/product')
const User = require('../models/user')
const userRouter = express.Router()

userRouter.post('/api/add-to-cart', auth, async function (req, res) {
  try {
    const { id } = req.body
    const product = await Product.findById(id)
    let user = await User.findById(req.user)

    if (user.cart.length === 0) {
      user.cart.push({ product, quantity: 1 })
    } else {
      let isProductFound = false
      for (let index = 0; index < user.cart.length; index++) {
        if (user.cart[index].product._id.equals(id)) {
          isProductFound = true
        }
      }

      if (isProductFound) {
        const producttt = user.cart.find((productt) => productt.product._id.equals(product._id))

        producttt.quantity += 1
      } else {
        user.cart.push({ product, quantity: 1 })
      }
    }

    user = await user.save()
    res.json(user)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

userRouter.delete('/api/remove-from-cart/:id', auth, async function (req, res) {
  try {
    const { id } = req.params
    const product = await Product.findById(id)
    let user = await User.findById(req.user)

    for (let index = 0; index < user.cart.length; index++) {
      if (user.cart[index].product._id.equals(product._id)) {
        if (user.cart[index].quantity === 1) {
          user.cart.splice(index, 1)
        } else {
          user.cart[index].quantity -= 1
        }
      }
    }

    user = await user.save()

    res.json(user)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

module.exports = userRouter
