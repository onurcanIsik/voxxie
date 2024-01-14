import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';

class VoxDetailPage extends StatefulWidget {
  final String petImage;
  final String petInfo;
  final String petName;
  final String petGen;
  const VoxDetailPage({
    super.key,
    required this.petImage,
    required this.petInfo,
    required this.petName,
    required this.petGen,
  });

  @override
  State<VoxDetailPage> createState() => _VoxDetailPageState();
}

class _VoxDetailPageState extends State<VoxDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _appBar(),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              widget.petImage,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            'Pet Name: ${widget.petName}',
            style: GoogleFonts.fredoka(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: txtColor,
            ),
          ),
          Text(
            'pet Genus: ${widget.petGen}',
            style: GoogleFonts.fredoka(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: txtColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 5, top: 20),
            child: Wrap(
              children: [
                Text(
                  widget.petInfo,
                  style: GoogleFonts.fredoka(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: txtColor,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          BtnWidget(
            topPdng: 0,
            btnHeight: 70,
            btnText: 'Send to mail',
            btnWidth: 300,
            btnFunc: () {},
          ),
          const Spacer(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        'Missing',
        style: GoogleFonts.fredoka(
          fontSize: 21,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
