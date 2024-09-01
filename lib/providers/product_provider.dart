import 'dart:io';

import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/core/models/rating_model.dart';
import 'package:amazon_clone/features/admin/services/admin_service.dart';
import 'package:amazon_clone/features/home/services/home_service.dart';
import 'package:amazon_clone/features/product_details/services/product_details_service.dart';
import 'package:amazon_clone/features/search/services/search_service.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  // services
  final _adminService = AdminService();
  final _homeService = HomeService();
  final _searchService = SearchService();
  final _productDetailsService = ProductDetailsService();

  /// products
  List<ProductModel> productsAll = [];
  List<ProductModel> productsCategory = [];
  List<ProductModel> productsSearched = [];
  ProductModel? product;

  /// loadings
  bool _isFetchingAllProducts = false;
  bool _isDeleting = false;
  bool _isFetchingCategoryProducts = false;
  bool _isFetchingSearchedProducts = false;
  bool _isRatingProduct = false;
  bool _isFetchingDealOfDay = false;

  bool get isFetchingAllProducts => _isFetchingAllProducts;

  bool get isDeleteting => _isDeleting;

  bool get isFetchingCategoryProducts => _isFetchingCategoryProducts;

  bool get isFetchingSearchedProducts => _isFetchingSearchedProducts;

  bool get isRatingProduct => _isRatingProduct;

  bool get isFetchingDealOfDay => _isFetchingDealOfDay;

  Future<void> fetchAllProducts(BuildContext context) async {
    _isFetchingAllProducts = true;
    notifyListeners();

    productsAll = await _adminService.fetchAllProducts(context);

    _isFetchingAllProducts = false;
    notifyListeners();
  }

  Future<void> sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required List<File> images,
    required List<RatingModel> ratings,
  }) async {
    await _adminService.sellProduct(
      context: context,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      category: category,
      images: images,
      ratings: ratings,
      onSuccess: () async {
        await fetchAllProducts(context);

        if (context.mounted) {
          showSnackBar(context, 'Product added successfuly');
          Navigator.pop(context);
        }
      },
    );

    notifyListeners();
  }

  Future<void> deleteProduct({
    required BuildContext context,
    required String productId,
  }) async {
    _isDeleting = true;
    notifyListeners();

    await _adminService.deleteProduct(
      context: context,
      productId: productId,
      onSuccess: () async => await fetchAllProducts(context),
    );

    _isDeleting = false;
    notifyListeners();
  }

  Future<void> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    _isFetchingCategoryProducts = true;
    notifyListeners();

    productsCategory = await _homeService.fetchCategoryProducts(
      context: context,
      category: category,
    );

    _isFetchingCategoryProducts = false;
    notifyListeners();
  }

  Future<void> fetchSearchedProducts({
    required BuildContext context,
    required String searchQuery,
  }) async {
    _isFetchingSearchedProducts = true;
    notifyListeners();

    productsSearched = await _searchService.fetchSearchedProducts(
      context: context,
      searchQuery: searchQuery,
    );

    _isFetchingSearchedProducts = false;
    notifyListeners();
  }

  Future<void> rateProduct({
    required BuildContext context,
    required String productId,
    required double rating,
  }) async {
    _isRatingProduct = true;
    notifyListeners();

    await _productDetailsService.rateProduct(
      context: context,
      productId: productId,
      rating: rating,
    );

    _isRatingProduct = false;
    notifyListeners();
  }

  Future<void> fetchDealOfDay({
    required BuildContext context,
  }) async {
    _isFetchingDealOfDay = true;
    notifyListeners();

    product = await _homeService.fetchDealOfDay(context: context);

    _isFetchingDealOfDay = false;
    notifyListeners();
  }
}
