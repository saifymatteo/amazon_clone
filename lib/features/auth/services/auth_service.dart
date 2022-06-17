import 'dart:convert';
import 'dart:developer';

import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Sign Up function
  Future<void> signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    // Try and catch block for async
    try {
      // Instantiate new User
      final user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      // Make sign up request
      final res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Handle any error
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Sign In function
  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    // Try and catch block for async
    try {
      // Make sign in request
      final res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Handle any error
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          // Initialize [SharedPreferences]
          final pref = await SharedPreferences.getInstance();

          // Get [User] Provider and call [setUser] method
          final user = userProvider(context: context)..setUser(res.body);

          // Add String key to [SharedPreference]
          await pref.setString(
            'x-auth-token',
            (jsonDecode(res.body) as Map<String, dynamic>)['token'].toString(),
          );

          // Check for user type
          if (user.user.type == 'user') {
            // Navigate to [HomeScreen]
            navigatePushNamed(
              context: context,
              routename: BottomBar.routeName,
            );
          } else {
            // Navigate to [AdminScreen]
            navigatePushNamed(
              context: context,
              routename: AdminScreen.routeName,
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Get user data function
  Future<void> getUserData({
    required BuildContext context,
  }) async {
    // Try and catch block for async
    try {
      // Initialize [SharedPreferences]
      final pref = await SharedPreferences.getInstance();

      // Get token from [SharePreferences]
      final token = pref.getString('x-auth-token');

      // Needed for automatic log in to work
      log('Token: $token');

      // Check for null with [token]
      if (token == null) {
        await pref.setString('x-auth-token', '');
      }

      // Make token request
      final tokenRes = await http.post(
        Uri.parse('$uri/api/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      // Decode the token request
      final response = jsonDecode(tokenRes.body) as bool;

      // Check the decoded request
      if (response == true) {
        final userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        // Set the user
        userProvider(context: context).setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
