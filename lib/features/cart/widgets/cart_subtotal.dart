import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    num sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'])
        .toList();

    return Row(
      children: [
        const Text(
          'Subtotal ',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Text(
          '\$$sum',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
