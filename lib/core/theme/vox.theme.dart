import 'package:flutter/material.dart';
import 'package:voxxie/colors/colors.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: bgColor,
      );

  static ThemeData get darkTheme => ThemeData(
        scaffoldBackgroundColor: btnColor,
      );
}
