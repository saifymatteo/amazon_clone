import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminService {
  // Sell Product route
  Future<void> sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    // Initialize user Provider
    final userProv = Provider.of<UserProvider>(context, listen: false);

    // Try and catch block
    try {
      // Initialize Cloudinary and empty images List
      final cloudinary = CloudinaryPublic('saifymatteo', 'hass1dih');
      final imageUrls = <String>[];

      // Iterate [images]
      for (var i = 0; i < images.length; i++) {
        // Upload to Cloudinary and store the response
        final res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        // Add the response url to images List
        imageUrls.add(res.secureUrl);
      }

      // Instantiate new Product with new url from Cloudinary
      final product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      // Send it to the server
      final res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
        body: product.toJson(),
      );

      // Handle any error
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product added successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Fetch admin product route
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    // Initialize userProvider and empty List
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final productList = <Product>[];

    // Try and catch block for http
    try {
      // Get the List
      final res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
      );

      // Store the decoded list
      final body = jsonDecode(res.body) as List;

      // Handle any error
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Iterate through the decoded list
          for (var i = 0; i < body.length; i++) {
            productList.add(
              // Add to master List
              Product.fromJson(
                jsonEncode(body[i]), // Encode the decoded List back to json
              ),
            );
          }
        },
      );
    } catch (e) {
      log('Error: $e');
      showSnackBar(context, e.toString());
    }

    return productList;
  }

  Future<void> deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProv = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
        body: jsonEncode({'id': product.id!}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
