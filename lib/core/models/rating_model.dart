class RatingModel {
  final String userId;
  final double rating;

  RatingModel({
    required this.userId,
    required this.rating,
  });

  factory RatingModel.fromJson(Map<String, Object?> json) {
    final String userId = json['userId'] as String;
    final double rating = !(json['rating'].toString()).contains('.')
        ? double.parse(json['rating'].toString())
        : json['rating'] as double;

    return RatingModel(
      userId: userId,
      rating: rating,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'rating': rating,
    };
  }

  @override
  String toString() {
    return 'RatingModel{rating: $rating}';
  }
}
