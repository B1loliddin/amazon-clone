import 'dart:convert';

import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/constants/error_handling.dart';
import 'package:amazon_clone/core/constants/secrets/app_secrets.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressService {
  // api
  static const String apiSaveUserAddress = '/api/save-user-address';
  static const String apiOrder = '/api/order';

  String _getUserToken(BuildContext context) {
    return context.mounted ? context.read<UserProvider>().user.token : '';
  }

  Future<void> saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    try {
      final userProvider = context.read<UserProvider>();

      late final Map<String, String> headers;
      if (context.mounted) {
        headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': _getUserToken(context),
        };
      }

      final uri = Uri.http(
        AppSecrets.baseUrl,
        AddressService.apiSaveUserAddress,
      );
      final body = {'address': address};

      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: headers,
      );

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () {
            final address = jsonDecode(response.body)['address'];
            final user = userProvider.user.copyWith(
              address: address,
            );
            userProvider.setUserFromModel(user);
          },
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
  }

  Future<void> placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    try {
      final userProvider = context.read<UserProvider>();

      late final Map<String, String> headers;
      if (context.mounted) {
        headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': _getUserToken(context),
        };
      }

      final uri = Uri.http(
        AppSecrets.baseUrl,
        AddressService.apiOrder,
      );
      final body = {
        'cart': userProvider.user.cart,
        'address': address,
        'totalPrice': totalSum,
      };

      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: headers,
      );

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () {
            final user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromModel(user);
            showSnackBar(context, 'Your order has been placed');
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
  }
}
