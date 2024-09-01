import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/features/search/widgets/searched_product_item.dart';
import 'package:amazon_clone/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;

  const SearchScreen({super.key, required this.searchQuery});

  static const String routeName = '/search-screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _fetchSearchedProducts();
      },
    );
  }

  // functions
  void _fetchSearchedProducts() async {
    await context.read<ProductProvider>().fetchSearchedProducts(
          context: context,
          searchQuery: widget.searchQuery,
        );
  }

  void _navigateToProductDetailsScreen(ProductModel product) {
    Navigator.pushNamed(
      context,
      ProductDetailsScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final phonePadding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            height: 40,
            child: TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: GlobalVariables.whiteColor,
                hintText: 'Search Amazon.com',
                prefixIcon: Icon(Icons.search),
                hintStyle:
                    TextStyle(color: GlobalVariables.blackFiftyFourColor),
                contentPadding: EdgeInsets.only(top: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GlobalVariables.blackTwelveColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GlobalVariables.blackThirtyEightColor,
                  ),
                ),
              ),
            ),
          ),
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
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.sizeOf(context).width, 10),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
            child: SizedBox(
              height: 10,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          /// #address box
          const AddressBox(),

          /// #
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return Stack(
                  children: [
                    /// #main content
                    ListView.separated(
                      padding: EdgeInsets.only(
                        top: 15,
                        bottom: phonePadding.bottom + 20,
                      ),
                      itemCount: productProvider.productsSearched.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.productsSearched[index];

                        return GestureDetector(
                          onTap: () => _navigateToProductDetailsScreen(product),
                          child: SearchedProductItem(product: product),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 25),
                    ),

                    /// #loader
                    if (productProvider.isFetchingSearchedProducts)
                      const Center(
                        child: Loader(),
                      )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
