import 'dart:convert';
import 'dart:developer';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchAllOrders({
    required BuildContext context,
  }) async {
    final userProv = userProvider(context: context);
    final orderList = <Order>[];

    try {
      final res = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProv.user.token
        },
      );

      // Store the decoded list
      final body = jsonDecode(res.body) as List;

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

  Future<void> logOut(BuildContext context) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      await sharedPreferences.setString('x-auth-token', '');

      await navigatePushNamedRemovedUntil(
        context: context,
        routename: AuthScreen.routeName,
      );
    } catch (e) {
      log('logOut: $e');
      showSnackBar(context, e.toString());
    }
  }
}
