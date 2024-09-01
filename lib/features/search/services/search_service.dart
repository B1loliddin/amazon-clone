import 'dart:convert';

import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/constants/error_handling.dart';
import 'package:amazon_clone/core/constants/secrets/app_secrets.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchService {
  // api
  static const String apiProductsSearch = '/api/products/search';

  String _getUserToken(BuildContext context) {
    return context.mounted ? context.read<UserProvider>().user.token : '';
  }

  Future<List<ProductModel>> fetchSearchedProducts({
    required BuildContext context,
    required String searchQuery,
  }) async {
    try {
      List<ProductModel> products = [];

      final uri = Uri.http(
        AppSecrets.baseUrl,
        '${SearchService.apiProductsSearch}/$searchQuery',
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
}
