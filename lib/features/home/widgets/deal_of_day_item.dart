import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DealOfDayItem extends StatefulWidget {
  const DealOfDayItem({super.key});

  @override
  State<DealOfDayItem> createState() => _DealOfDayItemState();
}

class _DealOfDayItemState extends State<DealOfDayItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _fetchDealOfDay(),
    );
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

  void _fetchDealOfDay() async =>
      await context.read<ProductProvider>().fetchDealOfDay(context: context);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final product = productProvider.product;

        return product == null
            ? const Center(
                child: Loader(),
              )
            : Stack(
                children: [
                  /// #main content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// #product image
                      SizedBox(
                        height: 235,
                        width: MediaQuery.sizeOf(context).width,
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(product.images[0]),
                          errorBuilder: _errorBuilder,
                          loadingBuilder: _loadingBuilder,
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// #product price, name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${product.price}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// #images
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: product.images.map(
                            (image) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(image),
                                    errorBuilder: _errorBuilder,
                                    loadingBuilder: _loadingBuilder,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// #see all deals text button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            overlayColor: GlobalVariables.selectedNavBarColor,
                          ),
                          child: Text(
                            'See all deals',
                            style: TextStyle(
                              color: GlobalVariables.selectedNavBarColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// #loader
                  if (productProvider.isFetchingDealOfDay)
                    const Center(
                      child: Loader(),
                    )
                ],
              );
      },
    );
  }
}
