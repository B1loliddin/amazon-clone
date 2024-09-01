class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  final String token;
  List<dynamic> cart;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });

  factory UserModel.fromJson(Map<String, Object?> json) {
    final String id = json['_id'] as String;
    final String name = json['name'] as String;
    final String email = json['email'] as String;
    final String password = json['password'] as String;
    final String address = json['address'] as String;
    final String type = json['type'] as String;
    final String token = json['token'] as String;
    final List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(
      (json['cart'] as List).map(
        (x) => Map<String, dynamic>.from(x),
      ),
    );

    return UserModel(
      id: id,
      name: name,
      email: email,
      password: password,
      address: address,
      type: type,
      token: token,
      cart: cart,
    );
  }

  Map<String, Object?> toJson() {
    return {
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

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return UserModel(
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

  @override
  String toString() {
    return 'UserModel{name: $name, token: $token}';
  }
}
