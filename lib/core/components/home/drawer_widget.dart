// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/auth/auth.bloc.dart';
import 'package:voxxie/core/bloc/image/image.bloc.dart';
import 'package:voxxie/core/bloc/vox/vox.bloc.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/pages/auth/login.dart';
import 'package:voxxie/pages/home/vox/add_vox.dart';

Widget drawerWidget(BuildContext context) {
  final AuthManager authManager = AuthManager();
  return Drawer(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    backgroundColor: bgColor,
    child: ListView(
      children: [
        DrawerHeader(
          child: Image.asset('assets/images/voxxie_logo.png'),
        ),
        Card(
          color: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: GestureDetector(
            onTap: () {
              if (authManager.isVerified == false) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: 'You have to comfirm your mail on settings !',
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => VoxxieCubit(),
                        ),
                        BlocProvider(
                          create: (context) => ImageCubit(),
                        ),
                      ],
                      child: const AddVoxxiePage(),
                    ),
                  ),
                );
              }
            },
            child: ListTile(
              title: Center(
                child: Text(
                  'Add Vox',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Card(
          color: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: GestureDetector(
            onTap: () {
              logout(context);
              AuthManager().setLoggedIn(false);
            },
            child: ListTile(
              title: Center(
                child: Text(
                  'Logout',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ),
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
