import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/extensions/context.extension.dart';

class ChatsBubbleWidget extends StatefulWidget {
  final String txt;
  final String dateTime;
  final Radius? topLeft;
  final Radius? topRight;
  final Radius? bottomLeft;
  final Radius? bottomRight;
  const ChatsBubbleWidget({
    super.key,
    required this.txt,
    this.bottomLeft,
    this.bottomRight,
    this.topLeft,
    this.topRight,
    required this.dateTime,
  });

  @override
  State<ChatsBubbleWidget> createState() => _ChatsBubbleWidgetState();
}

class _ChatsBubbleWidgetState extends State<ChatsBubbleWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return Padding(
      padding: context.paddingAllLow * 0.5,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDarkTheme ? darkButtonPostColor : lightButtonPostColor,
          borderRadius: BorderRadius.only(
            bottomRight: widget.bottomRight ?? const Radius.circular(0),
            bottomLeft: widget.bottomLeft ?? const Radius.circular(0),
            topLeft: widget.topLeft ?? const Radius.circular(0),
            topRight: widget.topRight ?? const Radius.circular(0),
          ),
        ),
        child: Padding(
          padding: context.paddingAllLow * 0.5,
          child: Column(
            children: [
              Text(
                widget.txt,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                ),
              ),
              Text(
                widget.dateTime,
                style: GoogleFonts.fredoka(
                  color: Colors.grey[600],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
