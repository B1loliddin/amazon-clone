import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final lighTheme = ThemeData(
    colorScheme: const ColorScheme.light(primary: GlobalVariables.secondaryColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlobalVariables.secondaryColor,
        overlayColor: GlobalVariables.whiteColor,
        textStyle: const TextStyle(
          color: GlobalVariables.whiteColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: GlobalVariables.blackColor,
      ),
    ),
  );
}
