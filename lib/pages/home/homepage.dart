// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/auth/auth.bloc.dart';
import 'package:voxxie/core/bloc/profile/profile.bloc.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/bloc/vox/vox.bloc.dart';
import 'package:voxxie/core/components/home/voxCard.widget.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/pages/auth/login.dart';
import 'package:voxxie/pages/chat/my_chat_page.dart';
import 'package:voxxie/pages/home/vox/vox_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isInternetConnected;
  final uuid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    isInternetConnected = await InternetConnectionChecker().hasConnection;

    if (isInternetConnected == true) {
      null;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(),
            child: LoginPage(),
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VoxxieCubit()..getAllVox(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit()..getUserInfo(uuid),
        )
      ],
      child: Scaffold(
        appBar: _appBar(context),
        body: BlocBuilder<VoxxieCubit, VoxxieState>(
          builder: (context, state) {
            AuthManager().setLoggedIn(true);
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, VoxxieState state) {
    return Column(
      children: [
        Expanded(
          child: _buildVoxList(context, state),
        ),
      ],
    );
  }

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  final path = FirebaseFirestore.instance.collection('Voxx').orderBy(
        'voxDate',
        descending: false,
      );

  Widget _buildVoxList(BuildContext context, VoxxieState state) {
    return paginateData(context);
  }

  RefreshIndicator paginateData(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshChangeListener.refreshed = true;
        await context.read<VoxxieCubit>().getAllVox();
        return Future.value();
      },
      child: PaginateFirestore(
        onError: (e) => Center(
          child: Image.asset("assets/images/error.png"),
        ),
        onEmpty: Center(
          child: Image.asset(
            "assets/images/emptyPage.png",
            scale: 20,
          ),
        ),
        itemsPerPage: 3,
        itemBuilderType: PaginateBuilderType.listView,
        query: path,
        listeners: [
          refreshChangeListener,
        ],
        itemBuilder: (context, snapshot, index) {
          final Map<String, dynamic> data =
              snapshot[index].data() as Map<String, dynamic>;
          return GestureDetector(
            onTap: () {
              if (FirebaseAuth.instance.currentUser!.email ==
                  data['ownerMail']) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VoxDetailPage(
                    petImage: data['voxImage'],
                    petInfo: data['voxInfo'],
                    petName: data['voxName'],
                    petGen: data['voxGen'],
                    petOwnerMail: data['ownerMail'],
                    ownerID: data['userID'],
                  ),
                ),
              );
            },
            child: VoxCard(
              voxImage: data['voxImage'],
              voxName: data['voxName'],
              voxLoc: data['voxLoc'],
              voxInfo: data['voxInfo'],
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return AppBar(
      elevation: 10,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: isDarkTheme ? darkAppbarColorColor : lightAppbarColor,
      centerTitle: true,
      title: Text(
        'voxxie',
        style: GoogleFonts.fredoka(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyChatPhage(),
              ),
            );
          },
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}
