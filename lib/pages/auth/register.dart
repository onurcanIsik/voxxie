// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/auth/auth.bloc.dart';
import 'package:voxxie/core/bloc/image/image.bloc.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/components/auth/txt_form.widget.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:voxxie/pages/auth/login.dart';
import 'package:voxxie/pages/policy/policy.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isAccept = false;

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ImageCubit(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: btnColor),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 170,
                      width: 170,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/voxxie_logo.png'),
                        ),
                      ),
                    ),
                  ),
                  TxtFormWidget(
                    topPad: 40,
                    hintTxt:
                        LocaleKeys.authentication_page_username_text.locale,
                    controller: usernameController,
                    validatorTxt: (value) {
                      if (value!.isEmpty) {
                        return 'Can not be blank';
                      }
                      return null;
                    },
                    isVisible: false,
                    isObscure: false,
                  ),
                  TxtFormWidget(
                    topPad: 10,
                    hintTxt: "E-mail",
                    controller: emailController,
                    validatorTxt: (value) {
                      if (value!.isEmpty) {
                        return 'Can not be blank';
                      }
                      return null;
                    },
                    isVisible: true,
                    isObscure: false,
                  ),
                  TxtFormWidget(
                    topPad: 10,
                    hintTxt:
                        LocaleKeys.authentication_page_password_text.locale,
                    controller: passwordController,
                    validatorTxt: (value) {
                      if (value!.isEmpty) {
                        return 'Can not be blank';
                      }
                      return null;
                    },
                    isVisible: true,
                    isObscure: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: Colors.green,
                          value: isAccept,
                          onChanged: (value) {
                            setState(() {
                              isAccept = !isAccept;
                            });
                          },
                        ),
                        TextButton(
                          child: Text(
                            LocaleKeys
                                .authentication_page_privacy_policy_text.locale,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PolicyPage(),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  BtnWidget(
                    topPdng: 30,
                    btnHeight: 50,
                    btnText: LocaleKeys
                        .authentication_page_register_button_text.locale,
                    btnWidth: 200,
                    btnFunc: () async {
                      if (formKey.currentState!.validate()) {
                        if (isAccept == true) {
                          await context.read<AuthCubit>().userRegister(
                                emailController.text,
                                passwordController.text,
                                usernameController.text,
                                context,
                              );
                        } else {
                          return QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            text: LocaleKeys
                                .handle_texts_handle_privacy_policy.locale,
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => AuthCubit(),
                                child: LoginPage(),
                              ),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.fredoka(
                              color: isDarkTheme ? Colors.white : txtColor,
                            ),
                            children: [
                              TextSpan(
                                text: LocaleKeys
                                    .authentication_page_have_account_text1
                                    .locale,
                                style: GoogleFonts.fredoka(
                                  color: isDarkTheme ? Colors.white : txtColor,
                                ),
                              ),
                              TextSpan(
                                text: LocaleKeys
                                    .authentication_page_have_account_text2
                                    .locale,
                                style: GoogleFonts.fredoka(
                                  fontWeight: FontWeight.w800,
                                  color: isDarkTheme ? Colors.white : txtColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
