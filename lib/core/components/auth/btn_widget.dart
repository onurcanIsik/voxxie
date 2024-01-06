import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';

class BtnWidget extends StatefulWidget {
  final double topPdng;
  final String btnText;
  final double btnWidth;
  final double btnHeight;
  final Function btnFunc;
  const BtnWidget({
    super.key,
    required this.topPdng,
    required this.btnHeight,
    required this.btnText,
    required this.btnWidth,
    required this.btnFunc,
  });

  @override
  State<BtnWidget> createState() => _BtnWidgetState();
}

class _BtnWidgetState extends State<BtnWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.topPdng),
      child: SizedBox(
        height: widget.btnHeight,
        width: widget.btnWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: btnColor,
          ),
          onPressed: () {
            widget.btnFunc();
          },
          child: Text(
            widget.btnText,
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
