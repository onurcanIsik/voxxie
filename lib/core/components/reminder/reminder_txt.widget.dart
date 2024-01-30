import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/core/extensions/context.extension.dart';

class ReminderWidget extends StatefulWidget {
  final String? hintTxt;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final Function? onTap;
  final Widget? iconWidget;
  const ReminderWidget({
    super.key,
    required this.controller,
    required this.hintTxt,
    required this.validator,
    this.readOnly,
    this.onTap,
    this.iconWidget,
  });

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingAllLow * 0.7,
      child: SizedBox(
        height: context.dynamicHeight(0.07),
        width: context.dynamicWidth(0.5),
        child: TextFormField(
          onTap: () {
            widget.onTap!();
          },
          readOnly: widget.readOnly ?? false,
          validator: widget.validator,
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: widget.iconWidget,
            hintText: widget.hintTxt,
            hintStyle: GoogleFonts.fredoka(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
