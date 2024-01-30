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
import 'package:voxxie/pages/home/search/search_page.dart';
import 'package:voxxie/pages/home/vox/add_vox.dart';
import 'package:voxxie/pages/reminder/reminder.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({Key? key}) : super(key: key);

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
    const SearchPage(),
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
    final themeCubit = context.watch<ThemeCubit>();
    final isDarkThemeC = themeCubit.state.isDarkTheme ?? false;

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarsItems(),
        elevation: 10,
        currentIndex: selectedIndex,
        backgroundColor: isDarkThemeC ? darkOrangeColor : lightOrangeColor,
        showSelectedLabels: false,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

  List<BottomNavigationBarItem> _navBarsItems() {
    final themeCubit = context.watch<ThemeCubit>();
    final isDarkThemeC = themeCubit.state.isDarkTheme ?? false;

    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: '',
        backgroundColor:
            isDarkThemeC ? darkBottomBarColor : lightBottomBarColor,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.search),
        label: '',
        backgroundColor:
            isDarkThemeC ? darkBottomBarColor : lightBottomBarColor,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.add),
        label: '',
        backgroundColor:
            isDarkThemeC ? darkBottomBarColor : lightBottomBarColor,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.calendar_month_outlined),
        label: '',
        backgroundColor:
            isDarkThemeC ? darkBottomBarColor : lightBottomBarColor,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        label: '',
        backgroundColor:
            isDarkThemeC ? darkBottomBarColor : lightBottomBarColor,
      )
    ];
  }
}
