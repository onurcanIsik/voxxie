import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:voxxie/pages/home/mail/send_mail.dart';

class VoxDetailPage extends StatefulWidget {
  final String petImage;
  final String petInfo;
  final String petName;
  final String petGen;
  final String petOwnerMail;
  const VoxDetailPage({
    super.key,
    required this.petImage,
    required this.petInfo,
    required this.petName,
    required this.petGen,
    required this.petOwnerMail,
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
            child: CachedNetworkImage(
              imageUrl: widget.petImage,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Text(
            '${LocaleKeys.home_page_pet_name_text.locale}: ${widget.petName}',
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
            btnText: LocaleKeys.home_page_send_mail_text.locale,
            btnWidth: 300,
            btnFunc: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendMailPage(
                    ownerMail: widget.petOwnerMail,
                  ),
                ),
              );
            },
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
        LocaleKeys.home_page_missing_text.locale,
        style: GoogleFonts.fredoka(
          fontSize: 21,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
