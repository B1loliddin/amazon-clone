import 'dart:io';
import 'dart:convert';

import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/constants/error_handling.dart';
import 'package:amazon_clone/core/models/order_model.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/core/models/rating_model.dart';
import 'package:amazon_clone/features/admin/models/sales_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/core/constants/secrets/app_secrets.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminService {
  // cloudinary keys
  static const String cloudinaryCloudName = 'djddbgmvm';
  static const String cloudinaryUploadPresetName = 'fs6054zh';

  // admin api
  static const String apiAddProduct = '/admin/add-product';
  static const String apiGetProducts = '/admin/get-products';
  static const String apiDeleteProduct = '/admin/delete-product';
  static const String apiGetOrders = '/admin/get-orders';
  static const String apiChangeOrderStatus = '/admin/change-order-status';
  static const String apiAnalytics = '/admin/analytics';

  String _getAdminToken(BuildContext context) {
    return context.mounted ? context.read<UserProvider>().user.token : '';
  }

  /// This function fetches all the products from database.
  Future<List<ProductModel>> fetchAllProducts(BuildContext context) async {
    try {
      List<ProductModel> products = [];

      final uri = Uri.http(
        AppSecrets.baseUrl,
        AdminService.apiGetProducts,
      );
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getAdminToken(context),
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

  /// This function adds the product to the selling products.
  Future<void> sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required List<File> images,
    required VoidCallback onSuccess,
    required List<RatingModel> ratings,
  }) async {
    try {
      final cloudinary = CloudinaryPublic(
        AdminService.cloudinaryCloudName,
        AdminService.cloudinaryUploadPresetName,
      );

      final imageUrls = <String>[];

      for (final image in images) {
        final response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: name),
        );
        imageUrls.add(response.secureUrl);
      }

      final product = ProductModel(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        category: category,
        images: imageUrls,
        ratings: ratings,
      );
      late final Map<String, String> headers;
      if (context.mounted) {
        headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': _getAdminToken(context),
        };
      }
      final uri = Uri.http(AppSecrets.baseUrl, AdminService.apiAddProduct);

      final response = await http.post(
        uri,
        body: jsonEncode(product.toJson()),
        headers: headers,
      );

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: onSuccess,
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
  }

  /// This function deletes the product from database.
  Future<void> deleteProduct({
    required BuildContext context,
    required String productId,
    required VoidCallback onSuccess,
  }) async {
    try {
      final body = {'id': productId};
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getAdminToken(context),
      };
      final uri = Uri.http(AppSecrets.baseUrl, AdminService.apiDeleteProduct);

      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: headers,
      );

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: onSuccess,
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
  }

  /// This function fetches all orders from database.
  Future<List<OrderModel>> fetchAllOrders({
    required BuildContext context,
  }) async {
    try {
      List<OrderModel> orders = [];

      final uri = Uri.http(
        AppSecrets.baseUrl,
        AdminService.apiGetOrders,
      );
      // debugPrint(uri.path);

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getAdminToken(context),
      };
      final response = await http.get(uri, headers: headers);
      final responseBody = jsonDecode(response.body);
      // debugPrint(response.body);

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

  /// This functions changes the order status.
  Future<void> changeOrderStatus({
    required BuildContext context,
    required int status,
    required OrderModel order,
    required VoidCallback onSuccess,
  }) async {
    try {
      final body = {
        'id': order.id,
        'status': status,
      };
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getAdminToken(context),
      };
      final uri = Uri.http(
        AppSecrets.baseUrl,
        AdminService.apiChangeOrderStatus,
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
          onSuccess: onSuccess,
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
  }

  /// This function gets earnings from database.
  Future<Map<String, dynamic>> getEarnings({
    required BuildContext context,
  }) async {
    List<SalesModel> sales = [];
    int totalEarning = 0;

    try {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': _getAdminToken(context),
      };
      final uri = Uri.http(
        AppSecrets.baseUrl,
        AdminService.apiAnalytics,
      );

      final response = await http.get(uri, headers: headers);
      final responseBody = response.body;

      if (context.mounted) {
        httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            final response = jsonDecode(responseBody);
            totalEarning = response['totalEarnings'];
            sales = [
              SalesModel(
                label: 'Mobiles',
                earning: response['mobileEarnings'],
              ),
              SalesModel(
                label: 'Essentials',
                earning: response['essentialEarnings'],
              ),
              SalesModel(
                label: 'Books',
                earning: response['booksEarnings'],
              ),
              SalesModel(
                label: 'Appliances',
                earning: response['applianceEarnings'],
              ),
              SalesModel(
                label: 'Fashion',
                earning: response['fashionEarnings'],
              ),
            ];
          },
        );
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}
