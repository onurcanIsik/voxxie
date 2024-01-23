import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/image/image.bloc.dart';
import 'package:voxxie/core/bloc/ivox/ivox.bloc.dart';
import 'package:voxxie/core/bloc/settings/set.bloc.dart';
import 'package:voxxie/core/bloc/shared/set_user.bloc.dart';
import 'package:voxxie/core/components/profile/user_info.widget.dart';
import 'package:voxxie/core/shared/enums/shared_keys.dart';
import 'package:voxxie/core/shared/shared_manager.dart';
import 'package:voxxie/pages/settings/settings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userName = SharedManager.getString(SharedKeys.userName);
    final String? userImage = SharedManager.getString(SharedKeys.userImage);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => IVoxxieCubit()..getAllMyVoxxie(),
        ),
      ],
      child: Scaffold(
        appBar: _appBar(context),
        body: BlocBuilder<IVoxxieCubit, IVoxxieState>(
          builder: (context, state) {
            if (state is IVoxxieLoadedState) {
              final ivox = state.ivox;
              return UserInfoWidget(
                userName: userName!,
                userImage: userImage,
                userPostCount: ivox.length.toString(),
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
      centerTitle: true,
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
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => SettingsCubit(),
                    ),
                    BlocProvider(
                      create: (context) => ImageCubit(),
                    ),
                    BlocProvider(
                      create: (context) => SharedUserCubit(),
                    ),
                  ],
                  child: const SettingsPage(),
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
