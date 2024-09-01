import 'package:amazon_clone/core/models/rating_model.dart';

class ProductModel {
  final String? id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String category;
  final List<String> images;
  final List<RatingModel> ratings;

  const ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.images,
    required this.ratings,
  });

  factory ProductModel.fromJson(Map<String, Object?> json) {
    final String? id = json['_id'] as String?;
    final String name = json['name'] as String;
    final String description = json['description'] as String;
    final double price = !(json['price'].toString()).contains('.')
        ? double.parse(json['price'].toString())
        : json['price'] as double;
    final int quantity = json['quantity'] as int;
    final String category = json['category'] as String;
    final List<String> images = List<String>.from(json['images'] as List);
    final List<RatingModel> ratings = List.from(
      (json['ratings'] as List).map(
        (element) => RatingModel.fromJson(element),
      ),
    );

    return ProductModel(
      id: id,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      category: category,
      images: images,
      ratings: ratings,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'images': images,
      'ratings': ratings,
    };
  }

  @override
  String toString() {
    return 'ProductModel{name: $name}';
  }
}
