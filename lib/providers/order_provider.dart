import 'package:amazon_clone/core/models/order_model.dart';
import 'package:amazon_clone/features/admin/services/admin_service.dart';
import 'package:amazon_clone/features/profile/services/profile_service.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  // services
  final _profileService = ProfileService();
  final _adminService = AdminService();

  // orders
  List<OrderModel> ordersMy = [];
  List<OrderModel> ordersAll = [];
  Map<String, dynamic> earnings = {};

  // loadings
  bool _isFetchingMyOrders = false;
  bool _isFetchingAllOrders = false;
  bool _isChangingOrderStatus = false;
  bool _isGettingEarnings = false;

  bool get isFetchingMyOrders => _isFetchingMyOrders;

  bool get isFetchingAllOrders => _isFetchingAllOrders;

  bool get isChangingOrderStatus => _isChangingOrderStatus;

  bool get isGettingEarnings => _isGettingEarnings;

  Future<void> fetchMyOrders(BuildContext context) async {
    _isFetchingMyOrders = true;
    notifyListeners();

    ordersMy = await _profileService.fetchMyOrders(context: context);

    _isFetchingMyOrders = false;
    notifyListeners();
  }

  Future<void> fetchAllOrders(BuildContext context) async {
    _isFetchingAllOrders = true;
    notifyListeners();

    ordersAll = await _adminService.fetchAllOrders(context: context);

    _isFetchingAllOrders = false;
    notifyListeners();
  }

  Future<void> changeOrderStatus({
    required BuildContext context,
    required int status,
    required OrderModel order,
    required VoidCallback onSuccess,
  }) async {
    _isChangingOrderStatus = true;
    notifyListeners();

    await _adminService.changeOrderStatus(
      context: context,
      status: status,
      order: order,
      onSuccess: onSuccess,
    );

    _isChangingOrderStatus = false;
    notifyListeners();
  }

  Future<void> getEarnings(BuildContext context) async {
    _isGettingEarnings = true;
    notifyListeners();

    earnings = await _adminService.getEarnings(context: context);

    _isGettingEarnings = false;
    notifyListeners();
  }
}
