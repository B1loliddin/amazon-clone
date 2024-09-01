import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const DefaultButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          side: const BorderSide(width: 0),
          overlayColor: GlobalVariables.blackColor,
          backgroundColor: GlobalVariables.greyBackgroundColor,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(color: GlobalVariables.blackColor),
        ),
      ),
    );
  }
}
