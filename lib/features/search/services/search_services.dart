import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchServices {
  // Fetch category products route
  Future<List<Product>> fetchSearchProducts({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final productList = <Product>[];

    try {
      // GET product category
      final res = await http.get(
        Uri.parse('$uri/api/products/search/$searchQuery'),
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
      showSnackBar(context, e.toString());
    }

    return productList;
  }
}
