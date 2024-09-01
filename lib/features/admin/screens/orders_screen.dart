import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/core/models/order_model.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/features/profile/widgets/product_item.dart';
import 'package:amazon_clone/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _fetchAllOrders(),
    );
  }

  // functiond
  void _fetchAllOrders() async {
    await context.read<OrderProvider>().fetchAllOrders(context);
  }

  void _navigateToOrderDetailsScreen(OrderModel order) {
    Navigator.pushNamed(
      context,
      OrderDetailsScreen.routeName,
      arguments: order,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// #main content
          Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              return GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: orderProvider.ordersAll.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final order = orderProvider.ordersAll[index];

                  return GestureDetector(
                    onTap: () => _navigateToOrderDetailsScreen(order),
                    child: ProductItem(
                      imageUrl: order.products[0].images[0],
                    ),
                  );
                },
              );
            },
          ),

          /// #loader
          if (context.read<OrderProvider>().isFetchingAllOrders)
            Center(
              child: Loader(),
            )
        ],
      ),
    );
  }
}
