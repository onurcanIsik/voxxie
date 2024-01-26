// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';

class SettingsCardWidget extends StatefulWidget {
  final String txt;
  final IconData icon;
  final Function func;
  const SettingsCardWidget({
    super.key,
    required this.txt,
    required this.icon,
    required this.func,
  });

  @override
  State<SettingsCardWidget> createState() => _SettingsCardWidgetState();
}

class _SettingsCardWidgetState extends State<SettingsCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: btnColor,
      child: ListTile(
        title: Text(
          widget.txt,
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            widget.icon,
            color: Colors.white,
          ),
          onPressed: () {
            widget.func();
          },
        ),
      ),
    );
  }
}
