import 'dart:convert';

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  factory User.fromMap(Map<String, dynamic> map) {
    // Another one to avoid headache
    // final cartList = List<Rating>.from(
    //   (map['ratings'] as List<dynamic>).map(
    //     (x) => Rating.fromMap(x as Map<String, dynamic>),
    //   ),
    // ).cast<Rating>().toList();

    // TODO(saifymatteo): Check later
    final cartList = List<Map<String, dynamic>>.from(
      (map['cart'] as List<dynamic>).map(
        (x) => Map<String, dynamic>.from(x as Map),
      ),
    );

    return User(
      id: (map['_id'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      type: (map['type'] ?? '') as String,
      token: (map['token'] ?? '') as String,
      cart: cartList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  String toJson() => json.encode(toMap());

  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  final String token;
  final List<dynamic> cart;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
