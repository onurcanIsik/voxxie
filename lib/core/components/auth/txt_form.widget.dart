// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:voxxie/colors/colors.dart';

class TxtFormWidget extends StatefulWidget {
  final double topPad;
  final String hintTxt;
  final TextEditingController controller;
  final String? Function(String?)? validatorTxt;
  bool isVisible; // Bu değeri burada tutuyoruz
  bool isObscure;

  TxtFormWidget({
    super.key,
    required this.topPad,
    required this.hintTxt,
    required this.controller,
    required this.validatorTxt,
    required this.isVisible,
    required this.isObscure,
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
        style: TextStyle(color: txtColor),
        validator: widget.validatorTxt,
        controller: widget.controller,
        onTap: () {
          setState(() {
            widget.isVisible = !widget.isVisible;
          });
        },
        obscureText: widget.isObscure && !widget.isVisible,
        decoration: InputDecoration(
          suffixIcon: widget.isObscure == true
              ? widget.isVisible == false
                  ? const Icon(Icons.remove_red_eye_outlined)
                  : const Icon(Icons.remove_red_eye)
              : null,
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
