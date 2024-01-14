import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';

class VoxCard extends StatefulWidget {
  final String titleTxt;
  final String voxTxt;
  const VoxCard({
    super.key,
    required this.titleTxt,
    required this.voxTxt,
  });

  @override
  State<VoxCard> createState() => _VoxCardState();
}

class _VoxCardState extends State<VoxCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Text(
            widget.titleTxt,
            style: GoogleFonts.fredoka(
              fontSize: 18,
              color: logoColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            widget.voxTxt,
            style: GoogleFonts.fredoka(
              color: txtColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
