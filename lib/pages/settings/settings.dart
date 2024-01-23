// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/auth/auth.bloc.dart';
import 'package:voxxie/core/bloc/image/image.bloc.dart';
import 'package:voxxie/core/bloc/settings/set.bloc.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/components/auth/txt_form.widget.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/core/shared/enums/shared_keys.dart';
import 'package:voxxie/core/shared/shared_manager.dart';
import 'package:voxxie/main.dart';
import 'package:voxxie/pages/auth/login.dart';
import 'package:voxxie/pages/settings/email_verification.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerName = TextEditingController();
  String? img = '';

  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    final AuthManager authManager = AuthManager();
    final bool isDarkThemeC = context.watch<ThemeCubit>().state.isDarkTheme!;

    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Card(
            color: btnColor,
            child: ListTile(
              title: Text(
                'Email verification',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              trailing: authManager.isVerified == false
                  ? IconButton(
                      icon: const Icon(
                        Icons.mark_email_read,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmailVerification(),
                          ),
                        );
                      },
                    )
                  : const Icon(
                      Icons.verified_user,
                      color: Colors.greenAccent,
                    ),
            ),
          ),
          Card(
            color: btnColor,
            child: ListTile(
              title: Text(
                'Change Email',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                onPressed: () async {
                  AuthManager().setVerifiedIn(false);
                  _showBottomSheet(
                    context,
                    controllerEmail,
                    'Email',
                    () async {
                      await context.read<SettingsCubit>().updateMail(
                            controllerEmail.text,
                            context,
                          );
                      controllerEmail.clear();
                    },
                  );
                },
              ),
            ),
          ),
          Card(
            color: btnColor,
            child: ListTile(
              title: Text(
                'Change Username',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {
                  _showBottomSheet(
                    context,
                    controllerName,
                    'Username',
                    () async {
                      await context.read<SettingsCubit>().updateName(
                            controllerName.text,
                            context,
                          );
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                        (route) => false,
                      );

                      controllerName.clear();
                    },
                  );
                },
              ),
            ),
          ),
          Card(
            color: btnColor,
            child: ListTile(
              title: Text(
                'Change Profile Photo',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await context.read<ImageCubit>().setUserImage(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ),
          Card(
            color: btnColor,
            child: ListTile(
              title: Text(
                'Dark mode',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              trailing: Switch(
                value: SharedManager.getBool(SharedKeys.isDarkMode)!,
                onChanged: (value) {
                  setState(() {
                    isDarkTheme = !isDarkTheme;
                  });
                  if (value) {
                    context.read<ThemeCubit>().setDarkTheme();
                  } else {
                    context.read<ThemeCubit>().setLightTheme();
                  }
                },
              ),
            ),
          ),
          Card(
            color: Colors.redAccent,
            child: ListTile(
              title: Text(
                'Log out',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () {
                  logout(context);
                  AuthManager().setLoggedIn(false);
                },
              ),
            ),
          ),
          Card(
            color: isDarkThemeC ? bgColor : txtColor,
            child: ListTile(
              title: Text(
                'Delete Account',
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
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Divider(
              thickness: 2,
              height: 3,
              color: btnColor,
            ),
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset("assets/images/voxxie_logo.png"),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: btnColor,
      title: Text(
        'Settings',
        style: GoogleFonts.fredoka(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _showBottomSheet(
    BuildContext context,
    TextEditingController controller,
    String value,
    Function changeFunc,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 1200,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              TxtFormWidget(
                topPad: 30,
                hintTxt: "Change $value",
                controller: controller,
                validatorTxt: (value) {
                  return null;
                },
                isVisible: false,
                isObscure: false,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      changeFunc();
                    },
                    child: Text(
                      'Save',
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
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

  Future logout(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.signOut().then(
          (value) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => AuthCubit(),
                  child: LoginPage(),
                ),
              ),
              (route) => false),
        );
  }
}
