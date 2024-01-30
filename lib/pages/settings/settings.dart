// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

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
import 'package:voxxie/core/components/settings/settings_Card_widget.dart';
import 'package:voxxie/core/extensions/context.extension.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/core/util/enums/shared_keys.dart';
import 'package:voxxie/core/shared/shared_manager.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:voxxie/main.dart';
import 'package:voxxie/pages/auth/login.dart';
import 'package:voxxie/pages/settings/delete_account.dart';
import 'package:voxxie/pages/settings/email_verification.dart';
import 'package:voxxie/pages/settings/password.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? img = '';

  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    final AuthManager authManager = AuthManager();
    final bool isDarkThemeC = context.watch<ThemeCubit>().state.isDarkTheme!;

    return Scaffold(
      appBar: _appBar(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Card(
              color: btnColor,
              child: ListTile(
                title: Text(
                  LocaleKeys
                      .settings_page_settings_email_verification_text.locale,
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
            SettingsCardWidget(
              txt:
                  LocaleKeys.settings_page_settings_username_change_text.locale,
              icon: Icons.person,
              func: () async {
                _showBottomSheet(
                  context,
                  controllerName,
                  'Username',
                  () async {
                    if (controllerName.text.isEmpty) {
                      return QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: LocaleKeys
                            .handle_texts_username_cannot_empty_text.locale,
                      );
                    } else {
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
                    }
                  },
                );
              },
            ),
            SettingsCardWidget(
              txt: LocaleKeys.settings_page_change_password_text.locale,
              icon: Icons.password,
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ),
                );
              },
            ),
            SettingsCardWidget(
              txt: LocaleKeys.settings_page_settings_photo_change_text.locale,
              icon: Icons.photo,
              func: () async {
                await context.read<ImageCubit>().setUserImage(context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                  (route) => false,
                );
              },
            ),
            Card(
              color: btnColor,
              child: ListTile(
                title: Text(
                  LocaleKeys.settings_page_settings_darkmode_text.locale,
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                trailing: Switch(
                  value: SharedManager.getBool(SharedKeys.isDarkMode) ?? false,
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
                  LocaleKeys.settings_page_settings_logout_text.locale,
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
                  LocaleKeys.settings_page_settings_delete_account_text.locale,
                  style: GoogleFonts.fredoka(
                    color: isDarkThemeC ? txtColor : bgColor,
                    fontSize: 18,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeleteAccountPage(),
                      ),
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
              height: context.dynamicHeight(0.2),
              width: context.dynamicWidth(0.2),
              child: Image.asset("assets/images/voxxie_logo.png"),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
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
                hintTxt: "",
                controller: controller,
                validatorTxt: (value) {
                  if (value!.isEmpty) {
                    return LocaleKeys.handle_texts_cannot_blank_text.locale;
                  }
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
                      if (formKey.currentState!.validate()) {
                        changeFunc();
                      }
                    },
                    child: Text(
                      LocaleKeys.settings_page_show_btn_text.locale,
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
