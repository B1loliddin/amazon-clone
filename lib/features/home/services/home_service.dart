import 'dart:convert';

import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/constants/error_handling.dart';
import 'package:amazon_clone/core/constants/secrets/app_secrets.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomeService {
  // api
  static const String apiProducts = '/api/products';
  static const String apiDealOfDay = '/api/deal-of-day';

  String _getUserToken(BuildContext context) {
    return context.mounted ? context.read<UserProvider>().user.token : '';
  }

  /// This functions all the products based on the category.
  Future<List<ProductModel>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    try {
      List<ProductModel> products = [];

      final queryParameters = <String, String>{'category': category};
      final uri = Uri.http(
        AppSecrets.baseUrl,
        HomeService.apiProducts,
        queryParameters,
      );

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getUserToken(context),
      };
      final response = await http.get(uri, headers: headers);
      final responseBody = jsonDecode(response.body);

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () {
            for (final product in responseBody) {
              products.add(ProductModel.fromJson(product));
            }
          },
        );
      }

      return products;
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
      return [];
    }
  }

  /// This functions gets the most popular product for the day,
  /// based on the ratings.
  Future<ProductModel?> fetchDealOfDay({
    required BuildContext context,
  }) async {
    ProductModel? product;

    try {
      final uri = Uri.http(
        AppSecrets.baseUrl,
        HomeService.apiDealOfDay,
      );

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getUserToken(context),
      };
      final response = await http.get(uri, headers: headers);
      final responseBody = jsonDecode(response.body);

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () {
            product = ProductModel.fromJson(responseBody);
          },
        );
      }

      return product;
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
      return product;
    }
  }
}
