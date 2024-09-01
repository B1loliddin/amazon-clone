import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    String? validate(String? value) {
      if (value == null || value.isEmpty) {
        return 'Enter your $hintText';
      } else {
        return null;
      }
    }

    return TextFormField(
      controller: controller,
      validator: validate,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: GlobalVariables.blackColor,
            width: 0.7,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: GlobalVariables.blackColor,
            width: 0.7,
          ),
        ),
      ),
    );
  }
}
