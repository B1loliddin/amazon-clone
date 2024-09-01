import 'package:amazon_clone/core/common/widgets/stars.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:flutter/material.dart';

class SearchedProductItem extends StatefulWidget {
  final ProductModel product;

  const SearchedProductItem({super.key, required this.product});

  @override
  State<SearchedProductItem> createState() => _SearchedProductItemState();
}

class _SearchedProductItemState extends State<SearchedProductItem> {
  double averageRating = 0;

  @override
  void initState() {
    super.initState();
    _calculateRating();
  }

  // functions
  Center _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return const Center(
      child: Icon(
        Icons.error,
        color: GlobalVariables.redColor,
      ),
    );
  }

  Widget _loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) {
      return child;
    } else {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
  }

  void _calculateRating() {
    double totalRating = 0;

    for (int i = 0; i < widget.product.ratings.length; i++) {
      totalRating += widget.product.ratings[i].rating;
    }

    if (totalRating != 0) {
      averageRating = totalRating / widget.product.ratings.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 150,
        child: Row(
          children: [
            /// #image
            Expanded(
              flex: 2,
              child: Image(
                image: NetworkImage(widget.product.images[0]),
                fit: BoxFit.contain,
                height: 160,
                width: 200,
                errorBuilder: _errorBuilder,
                loadingBuilder: _loadingBuilder,
              ),
            ),
            const SizedBox(width: 15),

            /// #main content
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// #
                  Text(
                    widget.product.name,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  /// #
                  Stars(rating: averageRating),

                  /// #
                  Text(
                    '\$${widget.product.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),

                  /// #
                  const Text('Eligible for Free Shipping'),

                  /// #
                  const Text(
                    'In Stock',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
