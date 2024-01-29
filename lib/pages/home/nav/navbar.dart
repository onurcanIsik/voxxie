import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/image/image.bloc.dart';
import 'package:voxxie/core/bloc/profile/profile.bloc.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/bloc/shared/set_user.bloc.dart';
import 'package:voxxie/core/bloc/vox/vox.bloc.dart';
import 'package:voxxie/pages/home/homepage.dart';
import 'package:voxxie/pages/home/profile/profile.dart';
import 'package:voxxie/pages/home/vox/add_vox.dart';
import 'package:voxxie/pages/reminder/reminder.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  int selectedIndex = 0;

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => SharedUserCubit(),
        ),
      ],
      child: const HomePage(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VoxxieCubit(),
        ),
      ],
      child: const AddVoxxiePage(),
    ),
    const ReminderPage(),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => ImageCubit(),
        ),
      ],
      child: const ProfilePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkThemeC = context.watch<ThemeCubit>().state.isDarkTheme!;
    return Scaffold(
      extendBody: true,
      body: pages[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: DotNavigationBar(
          borderRadius: 12,
          marginR: const EdgeInsets.symmetric(horizontal: 60, vertical: 0),
          backgroundColor: isDarkThemeC ? bgColor : postBgColor,
          unselectedItemColor: isDarkThemeC ? Colors.grey : bgColor,
          onTap: changePage,
          currentIndex: selectedIndex,
          items: [
            DotNavigationBarItem(
              icon: const Icon(Icons.house_rounded),
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.add),
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
