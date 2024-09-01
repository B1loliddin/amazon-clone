import 'package:amazon_clone/app.dart';
import 'package:amazon_clone/providers/order_provider.dart';
import 'package:amazon_clone/providers/product_provider.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const AmazonClone(),
    ),
  );
}
