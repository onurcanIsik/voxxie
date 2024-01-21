import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/ivox/ivox.bloc.dart';
import 'package:voxxie/core/bloc/profile/profile.bloc.dart';
import 'package:voxxie/core/bloc/settings/set.bloc.dart';
import 'package:voxxie/core/components/profile/user_info.widget.dart';
import 'package:voxxie/pages/settings/settings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit()..getUserInfo(userID),
        ),
        BlocProvider(
          create: (context) => IVoxxieCubit()..getAllMyVoxxie(),
        ),
      ],
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: _appBar(context),
        body: BlocBuilder<IVoxxieCubit, IVoxxieState>(
          builder: (context, state) {
            if (state is IVoxxieLoadedState) {
              final ivox = state.ivox;

              return BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ProfileLoadedState) {
                    final userData = state.datas;
                    return UserInfoWidget(
                      userName: userData[0].userName.toString(),
                      userFollowers: "2312",
                      userImage: userData[0].userImage,
                      userPostCount: ivox.length.toString(),
                    );
                  }
                  if (state is ProfileErrorState) {
                    return const Center(
                      child: Text('Oopss something went wrong'),
                    );
                  }
                  return const Center(
                    child: Text('Try again later!'),
                  );
                },
              );
            }
            return Image.asset('assets/images/voxxie_logo.png');
          },
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: btnColor,
      title: Text(
        'Profile',
        style: GoogleFonts.fredoka(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SettingsCubit(),
                  child: SettingsPage(),
                ),
              ),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}
