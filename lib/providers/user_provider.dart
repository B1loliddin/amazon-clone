import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/core/models/user_model.dart';
import 'package:amazon_clone/features/address/services/address_service.dart';
import 'package:amazon_clone/features/cart/services/cart_service.dart';
import 'package:amazon_clone/features/product_details/services/product_details_service.dart';
import 'package:amazon_clone/features/profile/services/profile_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  // services
  final _productDetailsService = ProductDetailsService();
  final _cartService = CartService();
  final _addressService = AddressService();
  final _profileService = ProfileService();

  bool _isAddingToCart = false;
  bool _isIncreasingQuantity = false;
  bool _isDecreasingQuantity = false;
  bool _isSavingUserAddress = false;
  bool _isPlacingOrder = false;
  bool _isLoggingOut = false;

  bool get isAddingToCart => _isAddingToCart;

  bool get isIncreasingQuantity => _isIncreasingQuantity;

  bool get isDecreasingQuantity => _isDecreasingQuantity;

  bool get isSavingUserAddress => _isSavingUserAddress;

  bool get isPlacingOrder => _isPlacingOrder;

  bool get isLoggingOut => _isLoggingOut;

  // models
  UserModel _user = UserModel(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
  );

  UserModel get user => _user;

  void setUser(Map<String, Object?> json) {
    _user = UserModel.fromJson(json);
    notifyListeners();
  }

  void setUserFromModel(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> addToCart({
    required BuildContext context,
    required ProductModel product,
  }) async {
    _isAddingToCart = true;
    notifyListeners();

    await _productDetailsService.addToCart(
      context: context,
      product: product,
    );

    _isAddingToCart = false;
    notifyListeners();
  }

  Future<void> increaseQuantity({
    required BuildContext context,
    required ProductModel product,
  }) async {
    _isIncreasingQuantity = true;
    notifyListeners();

    await _productDetailsService.addToCart(
      context: context,
      product: product,
    );

    _isIncreasingQuantity = false;
    notifyListeners();
  }

  Future<void> decreaseQuantity({
    required BuildContext context,
    required ProductModel product,
  }) async {
    _isDecreasingQuantity = true;
    notifyListeners();

    await _cartService.removeFromCart(
      context: context,
      product: product,
    );

    _isDecreasingQuantity = false;
    notifyListeners();
  }

  Future<void> saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    _isSavingUserAddress = true;
    notifyListeners();

    await _addressService.saveUserAddress(
      context: context,
      address: address,
    );

    _isSavingUserAddress = false;
    notifyListeners();
  }

  Future<void> placeOrder({
    required BuildContext context,
    required String address,
    required String totalSum,
  }) async {
    _isPlacingOrder = true;
    notifyListeners();

    await _addressService.placeOrder(
      context: context,
      address: address,
      totalSum: double.parse(totalSum),
    );

    _isPlacingOrder = false;
    notifyListeners();
  }

  Future<void> logOut(BuildContext context) async {
    _isLoggingOut = true;
    notifyListeners();

    await _profileService.logOut(context: context);

    _isLoggingOut = false;
    notifyListeners();
  }
}
