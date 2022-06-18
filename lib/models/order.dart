// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:amazon_clone/models/product.dart';

class Order {
  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
  });

  factory Order.fromJson(String source) => Order.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  factory Order.fromMap(Map<String, dynamic> map) {
    // Just to avoid headache
    final product = List<Product>.from(
      (map['products'] as List).map(
        (x) => Product.fromMap(
          x['product'] as Map<String, dynamic>,
        ),
      ),
    );
    final quantity = List<int>.from(
      (map['products'] as List).map(
        (x) => x['quantity'],
      ),
    );

    return Order(
      id: (map['_id'] ?? '').toString(),
      products: map['products'] == null ? <Product>[] : product,
      quantity: map['products'] == null ? <int>[] : quantity,
      address: (map['address'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      orderedAt: num.parse(map['orderedAt'].toString()).toInt(),
      status: num.parse(map['status'].toString()).toInt(),
      totalPrice: (num.parse(map['totalPrice'].toString())).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
    };
  }

  String toJson() => json.encode(toMap());

  final String id;
  final List<Product> products;
  final List<int> quantity;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;
  final double totalPrice;
}
