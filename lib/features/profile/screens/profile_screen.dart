import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/core/models/order_model.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/features/profile/widgets/below_app_bar.dart';
import 'package:amazon_clone/features/profile/widgets/default_button.dart';
import 'package:amazon_clone/features/profile/widgets/product_item.dart';
import 'package:amazon_clone/providers/order_provider.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // images
  final list = [
    'https://images.unsplash.com/photo-1723754165998',
    'https://images.unsplash.com/photo-1723754165998-305df32c501e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw4fHx8ZW58MHx8fHx8',
    'https://images.unsplash.com/photo-1723754165998-305df32c501e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw4fHx8ZW58MHx8fHx8',
    'https://images.unsplash.com/photo-1723754165998-305df32c501e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw4fHx8ZW58MHx8fHx8',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _fetchMyOrders(),
    );
  }

  // functions
  void _fetchMyOrders() async =>
      await context.read<OrderProvider>().fetchMyOrders(context);

  void _navigateToOrderDetailsScreen(OrderModel order) {
    Navigator.pushNamed(
      context,
      OrderDetailsScreen.routeName,
      arguments: order,
    );
  }

  void _logOut() async => await context.read<UserProvider>().logOut(context);

  @override
  Widget build(BuildContext context) {
    final phonePadding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Image(
                width: 120,
                height: 45,
                color: GlobalVariables.blackColor,
                image: AssetImage('assets/images/amazon_in.png'),
              ),
            ),
            Row(
              children: [
                /// #notification button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined),
                ),

                /// #search button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ],
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
      body: Stack(
        children: [
          /// #main content
          Column(
            children: [
              /// #hello, user name text
              const BelowAppBar(),
              const SizedBox(height: 10),

              /// #main buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    /// #my orders, turn seller buttons
                    Row(
                      children: [
                        DefaultButton(
                          buttonText: 'Your Orders',
                          onPressed: () {},
                        ),
                        const SizedBox(width: 20),
                        DefaultButton(
                          buttonText: 'Turn Seller',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    /// #log out, my wish list buttons
                    Row(
                      children: [
                        DefaultButton(
                          buttonText: 'Log Out',
                          onPressed: _logOut,
                        ),
                        const SizedBox(width: 20),
                        DefaultButton(
                          buttonText: 'Your Wish List',
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// #your orders text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// #your orders text
                    const Text(
                      'Your Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /// #see all text button
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        overlayColor: GlobalVariables.blueColor,
                      ),
                      child: const Text(
                        'See all',
                        style: TextStyle(color: GlobalVariables.blueColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              /// #my orders list
              SizedBox(
                height: 160,
                child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    return ListView.separated(
                      itemCount: orderProvider.ordersMy.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        final order = orderProvider.ordersMy[index];

                        return GestureDetector(
                          onTap: () => _navigateToOrderDetailsScreen(order),
                          child: ProductItem(
                            imageUrl: order.products[0].images[0],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 15),
                    );
                  },
                ),
              )
            ],
          ),

          /// #loader
          if (context.read<OrderProvider>().isFetchingMyOrders)
            Center(
              child: Loader(),
            )
        ],
      ),
    );
  }
}
