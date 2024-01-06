import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/pages/auth/register.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      backgroundColor: bgColor,
      logo: Image.asset('assets/images/voxxie_logo.png'),
      loaderColor: btnColor,
      logoWidth: 100,
      durationInSeconds: 4,
      navigator: RegisterPage(),
    );
  }
}
