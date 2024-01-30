// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/chats/chats.bloc.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/extensions/context.extension.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:voxxie/model/chats/chats.model.dart';
import 'package:voxxie/pages/home/nav/navbar.dart';

class UserPageSearch extends StatelessWidget {
  final String? userImage;
  final String? userName;
  final String? ownerID;
  const UserPageSearch({
    super.key,
    required this.userImage,
    required this.userName,
    required this.ownerID,
  });

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final AuthManager authManager = AuthManager();
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          Padding(
            padding: context.paddingAllLow * 2,
            child: Container(
              height: context.dynamicHeight(0.3),
              width: context.dynamicWidth(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: userImage!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        userImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/placeholder.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          Text(
            userName!,
            style: GoogleFonts.fredoka(
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Divider(
              thickness: 2,
              height: 3,
              color: btnColor,
            ),
          ),
          BtnWidget(
            topPdng: 30,
            btnHeight: 50,
            btnText: LocaleKeys.home_page_send_text_message.locale,
            btnWidth: context.dynamicWidth(0.7),
            btnFunc: () async {
              if (authManager.isVerified == true) {
                await context.read<ChatsCubit>().setChats(
                      ChatsModel(
                        displayImage: userImage,
                        displayName: userName,
                        userID1: userID,
                        userID2: ownerID,
                        message: LocaleKeys
                            .chats_page_texts_first_auto_message.locale,
                        senderID: userID,
                      ),
                      context,
                    );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const NavbarPage(),
                  ),
                  (route) => false,
                );
              } else {
                return QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: LocaleKeys
                      .settings_page_settings_email_verification_text.locale,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return AppBar(
      elevation: 10,
      backgroundColor: isDarkTheme ? darkAppbarColorColor : lightAppbarColor,
      title: Text(
        LocaleKeys.user_serach_texts_appbar_text.locale,
      ),
    );
  }
}
