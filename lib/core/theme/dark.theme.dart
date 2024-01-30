import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';

@immutable
class DarkTheme {
  const DarkTheme._();

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: darkBgColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      color: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),
    inputDecorationTheme: buildInputDecorationTheme(),
  );
}

InputDecorationTheme buildInputDecorationTheme() {
  return InputDecorationTheme(
    filled: true,
    labelStyle: TextStyle(color: bgColor),
    isCollapsed: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    fillColor: txtColor,
    hintStyle: TextStyle(color: bgColor),
    iconColor: txtColor,
    errorStyle: GoogleFonts.manrope(
      color: Colors.red,
    ),
    border: buildOutlineInputBorder(),
    disabledBorder: buildOutlineInputBorder(),
    enabledBorder: buildOutlineInputBorder(),
    focusedBorder: buildOutlineInputBorder(),
    focusedErrorBorder: buildOutlineInputBorder(),
  );
}

OutlineInputBorder buildOutlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: bgColor,
    ),
  );
}
