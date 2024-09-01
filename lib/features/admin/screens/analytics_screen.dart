import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/features/admin/models/sales_model.dart';
import 'package:amazon_clone/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int? totalSales;
  List<SalesModel>? earnings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _getEarnings(),
    );
  }

  void _getEarnings() async {
    await context.read<OrderProvider>().getEarnings(context);

    if (mounted) {
      totalSales = context.read<OrderProvider>().earnings['totalEarnings'];
      earnings = context.read<OrderProvider>().earnings['sales'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// #main content
          Column(
            children: [
              Text(
                '\$$totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          /// #loader
          if (context.read<OrderProvider>().isGettingEarnings)
            Center(
              child: Loader(),
            )
        ],
      ),
    );
  }
}
