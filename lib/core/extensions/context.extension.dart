import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double dynamicWidth(double val) => MediaQuery.sizeOf(this).width * val;
  double dynamicHeight(double val) => MediaQuery.sizeOf(this).height * val;

  ThemeData get theme => Theme.of(this);
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingAllLow => EdgeInsets.all(dynamicHeight(0.01));
}
