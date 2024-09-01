import 'package:amazon_clone/core/common/widgets/custom_button.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/cart/widgets/cart_product_item.dart';
import 'package:amazon_clone/features/cart/widgets/cart_subtotal.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // variables
    final user = context.watch<UserProvider>().user;
    final phonePadding = MediaQuery.of(context).padding;

    // functions
    void navigateToAddressScreen() {
      num sum = 0;
      user.cart
          .map((e) => sum += e['quantity'] * e['product']['price'])
          .toList();

      Navigator.pushNamed(
        context,
        AddressScreen.routeName,
        arguments: sum.toString(),
      );
    }

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            AddressBox(),
            SizedBox(height: 10),

            /// #
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CartSubtotal(),
            ),
            SizedBox(height: 15),

            /// #
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomButton(
                onPressed: navigateToAddressScreen,
                text: 'Proceed to Buy (${user.cart.length} items)',
              ),
            ),
            const SizedBox(height: 15),
            ColoredBox(
              color: GlobalVariables.greyShade400Color,
              child: SizedBox(
                height: 1,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),

            /// #
            SizedBox(
              height: 550,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: user.cart.length,
                padding: EdgeInsets.only(top: 10, bottom: 20),
                itemBuilder: (_, index) => CartProductItem(index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
