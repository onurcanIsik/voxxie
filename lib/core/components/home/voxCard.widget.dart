import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/extensions/context.extension.dart';
import 'package:voxxie/core/text/locale_text.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';

class VoxCard extends StatefulWidget {
  final String voxImage;
  final String voxName;
  final String voxLoc;
  final String voxInfo;
  const VoxCard({
    super.key,
    required this.voxImage,
    required this.voxName,
    required this.voxLoc,
    required this.voxInfo,
  });

  @override
  State<VoxCard> createState() => _VoxCardState();
}

class _VoxCardState extends State<VoxCard> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return Padding(
      padding: context.paddingAllLow * 1.5,
      child: Container(
        height: context.dynamicHeight(0.5),
        decoration: BoxDecoration(
          color: isDarkTheme ? postBgColor : txtColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SizedBox(
              width: context.dynamicWidth(0.98),
              height: context.dynamicHeight(0.3),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.voxImage,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LocaleText(
                  text: LocaleKeys.home_page_missing_text,
                  txtStyle: GoogleFonts.fredoka(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            Padding(
              padding: context.paddingAllLow * 1.5,
              child: Row(
                children: [
                  LocaleText(
                    text: LocaleKeys.home_page_pet_name_text,
                    txtStyle: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: isDarkTheme ? bgColor : bgColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ": ${widget.voxName}",
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: isDarkTheme ? bgColor : bgColor,
                    ),
                  ),
                  const SizedBox(width: 50),
                  LocaleText(
                    text: LocaleKeys.home_page_location_text,
                    txtStyle: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: isDarkTheme ? bgColor : bgColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ": ${widget.voxLoc}",
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: isDarkTheme ? bgColor : bgColor,
                    ),
                  )
                ],
              ),
            ),
            LocaleText(
              text: LocaleKeys.home_page_info_text,
              txtStyle: GoogleFonts.fredoka(
                fontSize: 18,
                color: isDarkTheme ? bgColor : bgColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: context.dynamicWidth(0.85),
              child: AutoSizeText(
                widget.voxInfo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  color: isDarkTheme ? bgColor : bgColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
