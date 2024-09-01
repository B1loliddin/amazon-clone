import 'package:amazon_clone/core/common/widgets/custom_button.dart';
import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/core/models/order_model.dart';
import 'package:amazon_clone/providers/order_provider.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  static const String routeName = '/order-details-screen';

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  // !!! ONLY FOR ADMIN !!!
  void _changeOrderStatus(int status) {
    context.read<OrderProvider>().changeOrderStatus(
          context: context,
          status: status + 1,
          order: widget.order,
          onSuccess: () => setState(() => currentStep += 1),
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
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
                hintStyle: TextStyle(
                  color: GlobalVariables.blackFiftyFourColor,
                ),
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
      body: Scrollbar(
        child: Stack(
          children: [
            /// #main content
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  /// #view order details text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'View order details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// #order details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Date: ${DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt)}',
                              ),
                              Text('Order ID: ${widget.order.id}'),
                              Text('Order Total: \$${widget.order.totalPrice}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  /// #purchase details text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Purchase Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// #purchase details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            for (int i = 0;
                                i < widget.order.products.length;
                                i++)
                              Row(
                                children: [
                                  /// #
                                  Image(
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      widget.order.products[i].images[0],
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  /// #
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.order.products[i].name,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Qty: ${widget.order.quantity[i]}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// #tracking text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Tracking',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// #tracking
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Stepper(
                        currentStep: currentStep,
                        controlsBuilder: (context, details) {
                          if (user.type == 'admin') {
                            return CustomButton(
                              text: 'Done',
                              onPressed: () =>
                                  _changeOrderStatus(details.currentStep),
                            );
                          }

                          return SizedBox();
                        },
                        steps: [
                          Step(
                            title: const Text('Pending'),
                            content: const Text(
                              'Your order is yet to be delivered',
                            ),
                            isActive: currentStep > 0,
                            state: currentStep > 0
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                          Step(
                            title: const Text('Completed'),
                            content: const Text(
                              'Your order has been delivered, you are yet to sign.',
                            ),
                            isActive: currentStep > 1,
                            state: currentStep > 1
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                          Step(
                            title: const Text('Received'),
                            content: const Text(
                              'Your order has been delivered and signed by you.',
                            ),
                            isActive: currentStep > 2,
                            state: currentStep > 2
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                          Step(
                            title: const Text('Delivered'),
                            content: const Text(
                              'Your order has been delivered and signed by you!',
                            ),
                            isActive: currentStep >= 3,
                            state: currentStep >= 3
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// #bottom space
                  SizedBox(height: phonePadding.bottom + 30),
                ],
              ),
            ),

            /// #loader
            if (context.read<OrderProvider>().isChangingOrderStatus)
              Center(
                child: Loader(),
              )
          ],
        ),
      ),
    );
  }
}
