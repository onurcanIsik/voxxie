// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/auth/auth.bloc.dart';
import 'package:voxxie/core/bloc/image/image.bloc.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/components/auth/txt_form.widget.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/pages/auth/register.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthManager authManager = AuthManager();

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/voxxie_logo.png'),
                        ),
                      ),
                    ),
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
                    isVisible: false,
                    isObscure: false,
                  ),
                  TxtFormWidget(
                    topPad: 10,
                    hintTxt: "Password",
                    controller: passwordController,
                    validatorTxt: (value) {
                      if (value!.isEmpty) {
                        return 'Can not be blank';
                      }
                      return null;
                    },
                    isVisible: false,
                    isObscure: true,
                  ),
                  BtnWidget(
                    topPdng: 30,
                    btnHeight: 50,
                    btnText: "Login",
                    btnWidth: 200,
                    btnFunc: () async {
                      if (formKey.currentState!.validate()) {
                        bool internetChecker =
                            await InternetConnectionChecker().hasConnection;
                        if (internetChecker == true) {
                          await context.read<AuthCubit>().loginUser(
                                emailController.text,
                                passwordController.text,
                                context,
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
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => AuthCubit(),
                                  ),
                                  BlocProvider(
                                    create: (context) => ImageCubit(),
                                  )
                                ],
                                child: RegisterPage(),
                              ),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.fredoka(
                              color: txtColor,
                            ),
                            children: [
                              TextSpan(
                                text: "You don't have a",
                                style: GoogleFonts.fredoka(
                                  color: isDarkTheme ? Colors.white : txtColor,
                                ),
                              ),
                              TextSpan(
                                text: " account ?",
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
