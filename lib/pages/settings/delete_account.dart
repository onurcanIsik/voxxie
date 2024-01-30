// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/auth/auth.bloc.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:voxxie/pages/auth/login.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkThemeC = context.watch<ThemeCubit>().state.isDarkTheme!;
    return Scaffold(
      appBar: _appBar(context),
      body: Column(children: [
        Card(
          color: isDarkThemeC ? bgColor : txtColor,
          child: ListTile(
            title: Text(
              LocaleKeys.settings_page_settings_delete_account_text.locale,
              style: GoogleFonts.fredoka(
                color: isDarkThemeC ? txtColor : bgColor,
                fontSize: 18,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () async {
                await deleteUserAccount(context);
                await AuthManager().setLoggedIn(false);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => AuthCubit(),
                      child: LoginPage(),
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  AppBar _appBar(BuildContext context) {
    final bool isDarkThemeC = context.watch<ThemeCubit>().state.isDarkTheme!;
    return AppBar(
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: isDarkThemeC ? darkAppbarColorColor : lightAppbarColor,
      title: Text(
        LocaleKeys.settings_page_settings_appbar_text.locale,
        style: GoogleFonts.fredoka(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Future<void> deleteUserAccount(BuildContext context) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance.collection('Users').doc(userID).delete();
      await FirebaseAuth.instance.currentUser!.delete();
      await AuthManager().setLoggedIn(false);
      return QuickAlert.show(context: context, type: QuickAlertType.success);
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete(context);
      } else {
        return QuickAlert.show(type: QuickAlertType.warning, context: context);
      }
    } catch (e) {
      return QuickAlert.show(type: QuickAlertType.error, context: context);
    }
  }

  Future<void> _reauthenticateAndDelete(BuildContext context) async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      final providerData = firebaseAuth.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await firebaseAuth.currentUser?.delete();
    } catch (e) {
      return QuickAlert.show(type: QuickAlertType.warning, context: context);
    }
  }
}
