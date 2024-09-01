import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String imageUrl;

  const ProductItem({super.key, required this.imageUrl});

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

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GlobalVariables.whiteColor,
        border: Border.all(
          width: 1.5,
          color: GlobalVariables.blackTwelveColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 180,
          height: 160,
          child: Image(
            fit: BoxFit.cover,
            errorBuilder: _errorBuilder,
            loadingBuilder: _loadingBuilder,
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}
