import 'dart:convert';

import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/constants/error_handling.dart';
import 'package:amazon_clone/core/constants/secrets/app_secrets.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/core/models/user_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartService {
  // api
  static const String apiRemoveFromCart = '/api/remove-from-cart';

  String _getUserToken(BuildContext context) {
    return context.mounted ? context.read<UserProvider>().user.token : '';
  }

  Future<void> removeFromCart({
    required BuildContext context,
    required ProductModel product,
  }) async {
    try {
      final userProvider = context.read<UserProvider>();

      final uri = Uri.http(
        AppSecrets.baseUrl,
        '${CartService.apiRemoveFromCart}/${product.id}',
      );
      // debugPrint(uri.path);

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getUserToken(context),
      };
      final response = await http.delete(uri, headers: headers);
      final responseBody = jsonDecode(response.body);
      debugPrint(response.body);

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () {
            UserModel user = userProvider.user.copyWith(
              cart: responseBody['cart'],
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
}
