import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    // Auth Screen route
    case AuthScreen.routeName:
      return MaterialPageRoute<Widget>(
        builder: (_) => const AuthScreen(),
        settings: routeSettings,
      );

    // Default route
    default:
      return MaterialPageRoute<Widget>(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Screen does not exist!')),
        ),
        settings: routeSettings,
      );
  }
}
