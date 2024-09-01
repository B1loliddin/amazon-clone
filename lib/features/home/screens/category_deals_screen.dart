import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryDealsScreen extends StatefulWidget {
  final String category;

  const CategoryDealsScreen({super.key, required this.category});

  static const String routeName = '/category-deals-screen';

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _fetchCategoryProducts();
      },
    );
  }

  // functions
  void _fetchCategoryProducts() async {
    await context.read<ProductProvider>().fetchCategoryProducts(
          context: context,
          category: widget.category,
        );
  }

  void _navigateToProductDetailsScreen(ProductModel product) {
    Navigator.pushNamed(
      context,
      ProductDetailsScreen.routeName,
      arguments: product,
    );
  }

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
    final phonePadding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(color: GlobalVariables.blackColor),
        ),
        flexibleSpace: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
          child: SizedBox(
            height: phonePadding.top + 56,
            width: MediaQuery.sizeOf(context).width,
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Stack(
            children: [
              /// #main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  /// #keep shoping for ${category}
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Keep shoping for ${widget.category}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// #products
                  SizedBox(
                    height: 170,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productProvider.productsCategory.length,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.2,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        final product = productProvider.productsCategory[index];

                        return GestureDetector(
                          onTap: () => _navigateToProductDetailsScreen(product),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// #product image
                              Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image(
                                        image: NetworkImage(product.images[0]),
                                        errorBuilder: _errorBuilder,
                                        loadingBuilder: _loadingBuilder,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),

                              /// #product name
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),

              /// #loader
              if (productProvider.isFetchingCategoryProducts)
                const Center(
                  child: Loader(),
                )
            ],
          );
        },
      ),
    );
  }
}
