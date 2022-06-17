import 'dart:convert';
import 'dart:developer';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartServices {
  // Remove from Cart
  Future<void> removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProv = userProvider(context: context);

    try {
      final res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
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
      log('removeFromCart: $e');
      showSnackBar(context, e.toString());
    }
  }
}
