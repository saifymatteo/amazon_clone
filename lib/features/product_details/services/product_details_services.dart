import 'dart:convert';
import 'dart:developer';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailsService {
  // Add to Card route
  Future<void> addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProv = userProvider(context: context);

    try {
      final res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final user = userProv.user.copyWith(
            // ignore: avoid_dynamic_calls
            cart: jsonDecode(res.body)['cart'] as List,
          );

          userProv.setUserFromModel(user);
        },
      );
    } catch (e) {
      log('addToCart: $e');
      showSnackBar(context, e.toString());
    }
  }

  // Rate product route
  Future<void> rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProv = userProvider(context: context);

    try {
      final res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
        body: jsonEncode({
          'id': product.id,
          'rating': rating,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      log('rateProduct: $e');
      showSnackBar(context, e.toString());
    }
  }
}
