import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: GlobalVariables.blackOpacity02Color,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
