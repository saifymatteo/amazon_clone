import 'dart:convert';

class Product {
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
  });

  factory Product.fromJson(String source) {
    return Product.fromMap(
      json.decode(source) as Map<String, dynamic>,
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      description: map['description'] as String,
      quantity: (num.parse(map['quantity'].toString())).toDouble(),
      images: List<String>.from(map['images'] as List),
      category: map['category'] as String,
      price: (num.parse(map['price'].toString())).toDouble(),
      id: map['_id'] != null ? map['_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
    };
  }

  final String name;
  final String description;
  final double quantity;
  final List<String> images;
  final String category;
  final double price;
  final String? id;
}
