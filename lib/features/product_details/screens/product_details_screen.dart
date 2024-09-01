import 'package:amazon_clone/core/common/widgets/custom_button.dart';
import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/core/common/widgets/stars.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/core/models/product_model.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/providers/product_provider.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  static const String routeName = '/product-details-screen';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  double averageRating = 0;
  double myRating = 0;

  @override
  void initState() {
    super.initState();
    _calculateRating();
  }

  // functions
  void _navigateToSearchScreen(String searchQuery) {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: searchQuery,
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

  void _rateProduct(double rating) async {
    context.read<ProductProvider>().rateProduct(
          context: context,
          productId: widget.product.id!,
          rating: rating,
        );
  }

  void _calculateRating() {
    double totalRating = 0;

    for (int i = 0; i < widget.product.ratings.length; i++) {
      totalRating += widget.product.ratings[i].rating;
      if (widget.product.ratings[i].userId ==
          context.read<UserProvider>().user.id) {
        myRating = widget.product.ratings[i].rating;
      }
    }

    if (totalRating != 0) {
      averageRating = totalRating / widget.product.ratings.length;
    }
  }

  void _addToCart() async {
    await context
        .read<UserProvider>()
        .addToCart(context: context, product: widget.product);
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
              onFieldSubmitted: _navigateToSearchScreen,
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
      body: Stack(
        children: [
          /// #main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// #product id, average rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// #product id
                      Text(
                        widget.product.id!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      /// #average rating
                      Stars(rating: averageRating),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                /// #product name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),

                /// #images
                CarouselSlider(
                  items: widget.product.images.map((image) {
                    return Builder(
                      builder: (context) => Image(
                        height: 200,
                        fit: BoxFit.contain,
                        image: NetworkImage(image),
                        errorBuilder: _errorBuilder,
                        loadingBuilder: _loadingBuilder,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 300,
                    viewportFraction: 1,
                    autoPlay: true,
                  ),
                ),
                ColoredBox(
                  color: GlobalVariables.blackTwelveColor,
                  child: SizedBox(
                    height: 5,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
                const SizedBox(height: 15),

                /// #price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    text: TextSpan(
                      text: 'Deal price: ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: '\$${widget.product.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: GlobalVariables.redColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                /// #product description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(widget.product.description),
                ),
                const SizedBox(height: 15),

                /// #buy now, add to cart buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      /// #but now button
                      CustomButton(
                        text: 'Buy Now',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 10),

                      /// #add to cart
                      CustomButton(
                        text: 'Add to Cart',
                        buttonColor: GlobalVariables.buttonYellowColor,
                        onPressed: _addToCart,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                /// #rate the product text, rating stars
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// #rate the product text
                      const Text(
                        'Rate The Product',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),

                      /// #rating stars
                      RatingBar.builder(
                        minRating: 0.5,
                        itemCount: 5,
                        initialRating: myRating,
                        allowHalfRating: true,
                        itemPadding: const EdgeInsets.only(left: 5),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: GlobalVariables.secondaryColor,
                        ),
                        onRatingUpdate: _rateProduct,
                      ),
                    ],
                  ),
                ),

                /// #bottom space
                SizedBox(height: phonePadding.bottom + 30),
              ],
            ),
          ),

          /// #loader
          if (context.read<ProductProvider>().isRatingProduct ||
              context.read<UserProvider>().isAddingToCart)
            const Center(
              child: Loader(),
            )
        ],
      ),
    );
  }
}
