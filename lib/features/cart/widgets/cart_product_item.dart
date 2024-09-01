import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProductItem extends StatefulWidget {
  final int index;

  const CartProductItem({super.key, required this.index});

  @override
  State<CartProductItem> createState() => _CartProductItemState();
}

class _CartProductItemState extends State<CartProductItem> {
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

  void _increaseQuantity(ProductModel product) async {
    await context
        .read<UserProvider>()
        .increaseQuantity(context: context, product: product);
  }

  void _decreaseQuantity(ProductModel product) async {
    await context
        .read<UserProvider>()
        .decreaseQuantity(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = ProductModel.fromJson(productCart['product']);
    final quantity = productCart['quantity'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          /// #
          Row(
            children: [
              /// #image
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 160,
                  width: 200,
                  child: Image(
                    image: NetworkImage(product.images[0]),
                    fit: BoxFit.cover,
                    errorBuilder: _errorBuilder,
                    loadingBuilder: _loadingBuilder,
                  ),
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
                      product.name,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    /// #
                    Text(
                      '\$${product.price}',
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

          /// #
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black12,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _decreaseQuantity(product),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: const Icon(
                            Icons.remove,
                            size: 18,
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(quantity.toString()),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _increaseQuantity(product),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: const Icon(
                            Icons.add,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
