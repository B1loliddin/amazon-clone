import 'dart:convert';

import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/constants/error_handling.dart';
import 'package:amazon_clone/core/constants/secrets/app_secrets.dart';
import 'package:amazon_clone/core/models/order_model.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  // api
  static const String apiMyOrders = '/api/orders/me';

  String _getAdminToken(BuildContext context) {
    return context.mounted ? context.read<UserProvider>().user.token : '';
  }

  /// This function fetches my orders from database.
  Future<List<OrderModel>> fetchMyOrders({
    required BuildContext context,
  }) async {
    try {
      List<OrderModel> orders = [];

      final uri = Uri.http(
        AppSecrets.baseUrl,
        ProfileService.apiMyOrders,
      );

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getAdminToken(context),
      };
      final response = await http.get(uri, headers: headers);
      final responseBody = jsonDecode(response.body);
      debugPrint(response.body);

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () {
            for (final order in responseBody) {
              orders.add(OrderModel.fromJson(order));
            }
          },
        );
      }

      return orders;
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
      return [];
    }
  }

  /// This function logs out user.
  ///
  /// This function deletes the token from local directory
  /// of the phone.
  Future<void> logOut({required BuildContext context}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      await sharedPreferences.setString('x-auth-token', '');

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AuthScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
    }
  }
}
