// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:voxxie/pages/chat/converstation_page.dart';

class MyChatPhage extends StatefulWidget {
  const MyChatPhage({super.key});

  @override
  State<MyChatPhage> createState() => _MyChatPhageState();
}

class _MyChatPhageState extends State<MyChatPhage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: _appBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('members', arrayContains: userID)
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.hasError) {
            return Image.asset('assets/images/error.png');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: data!.docs
                .map(
                  (doc) => GestureDetector(
                    onTap: () async {
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        text: LocaleKeys.chats_page_texts_alert_text.locale,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConverstationPage(
                            userName: doc['displayName'],
                            userID: userID,
                            conversationID: doc.id,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: postBgColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            doc['displayImage'],
                          ),
                        ),
                        title: Text(
                          doc['displayName'],
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: logoColor,
      title: Text(
        'My chats',
        style: GoogleFonts.fredoka(),
      ),
    );
  }
}
