import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxxie/core/bloc/chats/chats.bloc.dart';
import 'package:voxxie/core/bloc/profile/profile.bloc.dart';
import 'package:voxxie/core/bloc/settings/set.bloc.dart';
import 'package:voxxie/core/bloc/settings/settings_state.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/bloc/shared/set_user.bloc.dart';
import 'package:voxxie/core/constant/constant.dart';
import 'package:voxxie/core/shared/shared_manager.dart';
import 'package:voxxie/core/theme/dark.theme.dart';
import 'package:voxxie/core/theme/light.theme.dart';
import 'package:voxxie/firebase_options.dart';
import 'package:voxxie/core/util/localization/language_manager.dart';
import 'package:voxxie/pages/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedManager.init();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    EasyLocalization(
      supportedLocales: LanguageManager.instance.supportedLocales,
      path: ApplicationConstants.LANG_ASSET_PATH,
      fallbackLocale: LanguageManager.instance.supportedLocales.first,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.uid.isEmpty) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, SettinState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: context.watch<ThemeCubit>().state.isDarkTheme!
                  ? DarkTheme.darkTheme
                  : LightTheme.lightTheme,
              home: const SplashPage(),
            );
          },
        ),
      );
    } else {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
          BlocProvider(
            create: (context) => ProfileCubit()..getUserInfo(user.uid),
          ),
          BlocProvider(
            create: (context) => SharedUserCubit(),
          ),
          BlocProvider(
            create: (context) => SettingsCubit(),
          ),
          BlocProvider(
            create: (context) => ChatsCubit(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, SettinState>(
          builder: (context, state) {
            return BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoadedState) {
                  final userData = state.datas;
                  context.read<SharedUserCubit>().setUserData(
                        userData[0].userName.toString(),
                        userData[0].userImage.toString(),
                        userData[0].userMail.toString(),
                        context,
                      );
                }
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  theme: context.watch<ThemeCubit>().state.isDarkTheme!
                      ? DarkTheme.darkTheme
                      : LightTheme.lightTheme,
                  home: const SplashPage(),
                );
              },
            );
          },
        ),
      );
    }
  }
}
