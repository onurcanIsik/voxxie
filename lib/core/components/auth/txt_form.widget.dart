import 'package:flutter/material.dart';
import 'package:voxxie/colors/colors.dart';

class TxtFormWidget extends StatefulWidget {
  final double topPad;
  final String hintTxt;
  final TextEditingController controller;

  const TxtFormWidget({
    super.key,
    required this.topPad,
    required this.hintTxt,
    required this.controller,
  });

  @override
  State<TxtFormWidget> createState() => _TxtFormWidgetState();
}

class _TxtFormWidgetState extends State<TxtFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: widget.topPad),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintTxt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: btnColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: btnColor),
          ),
        ),
      ),
    );
  }
}
