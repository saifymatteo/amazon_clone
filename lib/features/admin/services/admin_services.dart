// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/models/order.dart';
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
      log('sellProduct: $e');
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
      log('fetchAllProducts: $e');
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
      log('deleteProduct: $e');
      showSnackBar(context, e.toString());
    }
  }

  // Fetch all orders route
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    // Initialize userProvider and empty List
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final orderList = <Order>[];

    // Try and catch block for http
    try {
      // Get the List
      final res = await http.get(
        Uri.parse('$uri/admin/get-orders'),
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
            orderList.add(
              // Add to master List
              Order.fromJson(
                jsonEncode(body[i]), // Encode the decoded List back to json
              ),
            );
          }
        },
      );
    } catch (e) {
      log('fetchAllOrders: $e');
      showSnackBar(context, e.toString());
    }

    return orderList;
  }

  Future<void> changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProv = userProvider(context: context);

    try {
      final res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
        body: jsonEncode({'id': order.id}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      log('changeOrderStatus: $e');
      showSnackBar(context, e.toString());
    }
  }

  // Get analytics
  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    // Initialize userProvider and empty List
    final userProv = Provider.of<UserProvider>(context, listen: false);
    var sales = <Sales>[];
    var totalEarning = 0;

    // Try and catch block for http
    try {
      // Get the List
      final res = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
      );

      // Handle any error
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final response = jsonDecode(res.body);

          totalEarning = response['totalEarning'] == null
              ? 0
              : response['totalEarning'] as int;

          sales = [
            Sales(
              'Mobiles',
              response['mobileEarnings'] == null
                  ? 0
                  : response['mobileEarnings'] as int,
            ),
            Sales(
              'Essentials',
              response['essentialsEarning'] == null
                  ? 0
                  : response['essentialsEarning'] as int,
            ),
            Sales(
              'Appliances',
              response['appliancesEarning'] == null
                  ? 0
                  : response['appliancesEarning'] as int,
            ),
            Sales(
              'Books',
              response['booksEarning'] == null
                  ? 0
                  : response['booksEarning'] as int,
            ),
            Sales(
              'Fashion',
              response['fashionEarning'] == null
                  ? 0
                  : response['fashionEarning'] as int,
            ),
          ];
        },
      );
    } catch (e) {
      log('getEarnings: $e');
      showSnackBar(context, e.toString());
    }

    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}
