// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:async';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/auth/auth.bloc.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/pages/auth/login.dart';
import 'package:voxxie/pages/home/homepage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _initAuthManager();
      }
    });
  }

  Future<void> _initAuthManager() async {
    final AuthManager authManager = AuthManager();
    await authManager.init();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AuthCubit(),
          child: _checkUserLoginStatus(),
        ),
      ),
    );
  }

  Widget _checkUserLoginStatus() {
    if (AuthManager().isLoggedIn == true) {
      return const HomePage();
    } else {
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      backgroundColor: bgColor,
      logo: Image.asset('assets/images/voxxie_logo.png'),
      loaderColor: btnColor,
      logoWidth: 100,
      durationInSeconds: 4,
      loadingText: Text(
        'Version 1.0.0',
        style: GoogleFonts.fredoka(),
      ),
    );
  }
}
