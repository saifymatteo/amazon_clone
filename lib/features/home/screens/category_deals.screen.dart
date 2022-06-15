import 'package:amazon_clone/constants/global_var.dart';
import 'package:flutter/material.dart';

class CategoryDealScreen extends StatefulWidget {
  const CategoryDealScreen({super.key, required this.category});

  final String category;
  static const String routeName = '/category-deals';

  @override
  State<CategoryDealScreen> createState() => _CategoryDealScreenState();
}

class _CategoryDealScreenState extends State<CategoryDealScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          // ignore: use_decorated_box
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.topLeft,
            child: Text(
              'Keep shopping for ${widget.category}',
              style: const TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
