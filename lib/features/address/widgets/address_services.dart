import 'dart:convert';
import 'dart:developer';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AddressService {
  Future<void> saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProv = userProvider(context: context);

    try {
      final res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
        body: jsonEncode({
          'address': address,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final user = userProv.user.copyWith(
            // ignore: avoid_dynamic_calls
            address: jsonDecode(res.body)['address'] as String,
          );

          userProv.setUserFromModel(user);
        },
      );
    } catch (e) {
      log('saveUserAddress: $e');
      showSnackBar(context, e.toString());
    }
  }

  Future<void> placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final userProv = userProvider(context: context);

    try {
      final res = await http.post(
        Uri.parse('$uri/api/order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token,
        },
        body: jsonEncode({
          'cart': userProv.user.cart,
          'address': address,
          'totalPrice': totalSum
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final user = userProv.user.copyWith(
            cart: [],
          );

          userProv.setUserFromModel(user);

          showSnackBar(context, 'Your order has been placed!');
        },
      );
    } catch (e) {
      log('placeOrder: $e');
      showSnackBar(context, e.toString());
    }
  }
}
