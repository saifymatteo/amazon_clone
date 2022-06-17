// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';

class CartSubTotal extends StatelessWidget {
  const CartSubTotal({super.key, required this.sum});

  final int sum;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Subtotal ',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '\$$sum',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
