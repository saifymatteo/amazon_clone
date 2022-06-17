import 'dart:convert';

class Rating {
  Rating({
    required this.userId,
    required this.rating,
  });

  factory Rating.fromJson(String source) =>
      Rating.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] as String,
      rating: (map['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'rating': rating,
    };
  }

  String toJson() => json.encode(toMap());

  final String userId;
  final double rating;
}
