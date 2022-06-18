import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/category_deals.screen.dart';
import 'package:amazon_clone/features/home/screens/home_screens.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
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

    // Search Screen route
    case SearchScreen.routeName:
      final searchQuery = routeSettings.arguments.toString();
      return MaterialPageRoute<Widget>(
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
        settings: routeSettings,
      );

    // Product Detail Screen route
    case ProductDetailScreen.routeName:
      final product = routeSettings.arguments! as Product;
      return MaterialPageRoute<Widget>(
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
        settings: routeSettings,
      );

    // Order Detail Screen route
    case OrderDetailsScreen.routeName:
      final order = routeSettings.arguments! as Order;
      return MaterialPageRoute<Widget>(
        builder: (_) => OrderDetailsScreen(
          order: order,
        ),
        settings: routeSettings,
      );

    // Address Screen route
    case AddressScreen.routeName:
      final totalAmount = routeSettings.arguments.toString();
      return MaterialPageRoute<Widget>(
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
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
