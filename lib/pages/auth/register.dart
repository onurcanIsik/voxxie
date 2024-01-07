// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/auth/auth.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/components/auth/txt_form.widget.dart';
import 'package:voxxie/pages/auth/login.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        backgroundColor: bgColor,
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
                    topPad: 40,
                    hintTxt: "Username",
                    controller: usernameController,
                    validatorTxt: (value) {
                      if (value!.isEmpty) {
                        return 'Can not be blank';
                      }
                      return null;
                    },
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
                  ),
                  BtnWidget(
                    topPdng: 30,
                    btnHeight: 50,
                    btnText: "Register",
                    btnWidth: 200,
                    btnFunc: () async {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthCubit>().userRegister(
                              emailController.text,
                              passwordController.text,
                              usernameController.text,
                              context,
                            );
                        context.read<AuthCubit>().setUserInfo(
                              emailController.text,
                              usernameController.text,
                              context,
                            );

                        emailController.clear();
                        passwordController.clear();
                        usernameController.clear();
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
                              builder: (context) => LoginPage(),
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
                                text: "You have already",
                                style: GoogleFonts.fredoka(),
                              ),
                              TextSpan(
                                text: " account ?",
                                style: GoogleFonts.fredoka(
                                  fontWeight: FontWeight.w800,
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
