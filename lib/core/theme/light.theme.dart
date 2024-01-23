import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';

@immutable
class LightTheme {
  const LightTheme._();

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: bgColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      color: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),
  );
}
