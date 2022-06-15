import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/category_deals.screen.dart';
import 'package:amazon_clone/features/home/screens/home_screens.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    // Auth Screen route
    case AuthScreen.routeName:
      return MaterialPageRoute<Widget>(
        builder: (_) => const AuthScreen(),
        settings: routeSettings,
      );

    // Home Screen route
    case HomeScreen.routeName:
      return MaterialPageRoute<Widget>(
        builder: (_) => const HomeScreen(),
        settings: routeSettings,
      );

    // First Screen route
    case BottomBar.routeName:
      return MaterialPageRoute<Widget>(
        builder: (_) => const BottomBar(),
        settings: routeSettings,
      );

    // Admin Screen route
    case AdminScreen.routeName:
      return MaterialPageRoute<Widget>(
        builder: (_) => const AdminScreen(),
        settings: routeSettings,
      );

    // Add Product route
    case AddProductScreen.routeName:
      return MaterialPageRoute<Widget>(
        builder: (_) => const AddProductScreen(),
        settings: routeSettings,
      );

    // Category Page route
    case CategoryDealScreen.routeName:
      final category = routeSettings.arguments.toString();
      return MaterialPageRoute<Widget>(
        builder: (_) => CategoryDealScreen(
          category: category,
        ),
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
