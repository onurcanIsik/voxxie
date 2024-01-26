import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';

class LocaleText extends StatelessWidget {
  final String? text;
  final TextStyle txtStyle;
  const LocaleText({
    super.key,
    @required this.text,
    required this.txtStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text!.locale,
      style: txtStyle,
    );
  }
}
