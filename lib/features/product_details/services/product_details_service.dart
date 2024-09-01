import 'dart:convert';

import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/constants/error_handling.dart';
import 'package:amazon_clone/core/constants/secrets/app_secrets.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsService {
  // api
  static const String apiRateProduct = '/api/rate-product';
  static const String apiAddToCart = '/api/add-to-cart';

  String _getUserToken(BuildContext context) {
    return context.mounted ? context.read<UserProvider>().user.token : '';
  }

  Future<void> rateProduct({
    required BuildContext context,
    required String productId,
    required double rating,
  }) async {
    try {
      final body = {
        'id': productId,
        'rating': rating,
      };
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getUserToken(context),
      };
      final uri = Uri.http(
        AppSecrets.baseUrl,
        ProductDetailsService.apiRateProduct,
      );

      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: headers,
      );

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () {},
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
  }

  Future<void> addToCart({
    required BuildContext context,
    required ProductModel product,
  }) async {
    try {
      final userProvider = context.read<UserProvider>();

      final body = {'id': product.id};
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getUserToken(context),
      };
      final uri = Uri.http(
        AppSecrets.baseUrl,
        ProductDetailsService.apiAddToCart,
      );

      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: headers,
      );
      // debugPrint(response.body.toString());

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () {
            final user = userProvider.user
                .copyWith(cart: jsonDecode(response.body)['cart']);
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
