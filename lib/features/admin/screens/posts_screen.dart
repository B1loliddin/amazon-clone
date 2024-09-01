import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/profile/widgets/product_item.dart';
import 'package:amazon_clone/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _fetchAllProducts();
      },
    );
  }

  // functions
  void _navigateToAddProductScreen() =>
      Navigator.pushNamed(context, AddProductScreen.routeName);

  void _fetchAllProducts() async =>
      await context.read<ProductProvider>().fetchAllProducts(context);

  void _deleteProduct(String productId) async {
    await context.read<ProductProvider>().deleteProduct(
          context: context,
          productId: productId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Stack(
            children: [
              /// #main content
              Scrollbar(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  itemCount: productProvider.productsAll.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 213,
                    crossAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    final product = productProvider.productsAll[index];

                    /// product content
                    return Column(
                      children: [
                        /// #product image
                        SizedBox(
                          height: 140,
                          child: ProductItem(
                            imageUrl: product.images[0],
                          ),
                        ),
                        const SizedBox(height: 10),

                        /// #product name, delete icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _deleteProduct(product.id!),
                              icon: const Icon(
                                Icons.delete_outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// #loader
              if (productProvider.isDeleteting ||
                  productProvider.isFetchingAllProducts)
                const Center(
                  child: Loader(),
                ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProductScreen,
        tooltip: 'Add a product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
