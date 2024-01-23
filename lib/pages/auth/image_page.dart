// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/image/image.bloc.dart';
import 'package:voxxie/core/bloc/profile/profile.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/pages/home/homepage.dart';

class SetImagePage extends StatelessWidget {
  const SetImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ImageCubit(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: btnColor),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProfileLoadedState) {
              final userImage = state.datas;
              return Column(
                children: [
                  Center(
                    child: Container(
                      height: 160,
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: NetworkImage(
                            userImage[0].userImage.toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: userImage[0].userImage != null
                          ? null
                          : Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.image,
                                  color: btnColor,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  await context
                                      .read<ImageCubit>()
                                      .setUserImage(context);
                                  await context
                                      .read<ProfileCubit>()
                                      .getUserInfo(userID);
                                },
                              ),
                            ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await context.read<ImageCubit>().setUserImage(context);
                      await context.read<ProfileCubit>().getUserInfo(userID);
                    },
                    child: Text(
                      "Change image",
                      style: GoogleFonts.fredoka(
                        color: btnColor,
                      ),
                    ),
                  ),
                  BtnWidget(
                    topPdng: 30,
                    btnHeight: 40,
                    btnText: "Register",
                    btnWidth: 150,
                    btnFunc: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                  )
                ],
              );
            }
            return Column(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.image,
                          color: btnColor,
                          size: 30,
                        ),
                        onPressed: () async {
                          await context
                              .read<ImageCubit>()
                              .setUserImage(context);
                          await context
                              .read<ProfileCubit>()
                              .getUserInfo(userID);
                        },
                      ),
                    ),
                  ),
                ),
                BtnWidget(
                  topPdng: 30,
                  btnHeight: 40,
                  btnText: "Register",
                  btnWidth: 150,
                  btnFunc: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
