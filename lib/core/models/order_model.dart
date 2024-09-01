import 'package:amazon_clone/core/models/product_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<ProductModel> products;
  final List<int> quantity;
  final String address;
  final int orderedAt;
  final int status;
  final double totalPrice;

  OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.quantity,
    required this.address,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
  });

  factory OrderModel.fromJson(Map<String, Object?> json) {
    final String id = json['_id'] as String;
    final String userId = json['userId'] as String;
    final List<ProductModel> products = List.from(
      (json['products'] as List).map(
        (element) => ProductModel.fromJson(element['product']),
      ),
    );
    final List<int> quantity = List.from((json['products'] as List).map(
      (element) => element['quantity'] as int,
    ));
    final String address = json['address'] as String;
    final int orderedAt = json['orderedAt'] as int;
    final int status = json['status'] as int;
    final double totalPrice = json['totalPrice'] as double;

    return OrderModel(
      id: id,
      userId: userId,
      products: products,
      quantity: quantity,
      address: address,
      orderedAt: orderedAt,
      status: status,
      totalPrice: totalPrice,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'userId': userId,
      'products': products,
      'quantity': quantity,
      'address': address,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
    };
  }
}
