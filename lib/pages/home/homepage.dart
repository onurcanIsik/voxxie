// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/auth/auth.bloc.dart';
import 'package:voxxie/core/bloc/profile/profile.bloc.dart';
import 'package:voxxie/core/bloc/vox/vox.bloc.dart';
import 'package:voxxie/core/components/home/drawer_widget.dart';
import 'package:voxxie/core/components/home/voxCard.widget.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/pages/auth/login.dart';
import 'package:voxxie/pages/home/profile/profile.dart';
import 'package:voxxie/pages/home/vox/vox_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isInternetConnected;

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
    return BlocProvider(
      create: (context) => VoxxieCubit()..getAllVox(),
      child: Scaffold(
        backgroundColor: bgColor,
        drawer: drawerWidget(context),
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
          child: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<VoxxieCubit>(context).getAllVox();
            },
            child: _buildVoxList(context, state),
          ),
        ),
      ],
    );
  }

  Widget _buildVoxList(BuildContext context, VoxxieState state) {
    if (state is VoxxieLoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is VoxxieLoadedState) {
      final voxData = state.allProduct;
      if (voxData.isEmpty) {
        return Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset(
              'assets/images/emptyPage.png',
            ),
          ),
        );
      }
      return ListView.builder(
        itemCount: voxData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoxDetailPage(
                      petImage: voxData[index].voxImage.toString(),
                      petInfo: voxData[index].voxInfo.toString(),
                      petGen: voxData[index].voxGen.toString(),
                      petName: voxData[index].voxName.toString(),
                      petOwnerMail: voxData[index].ownerMail.toString(),
                    ),
                  ),
                );
              },
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 158,
                              width: 150,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: Image.network(
                                  voxData[index].voxImage.toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                "Missing      ",
                                style: GoogleFonts.fredoka(
                                  fontSize: 20,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                voxData[index].date.toString(),
                                style: GoogleFonts.fredoka(
                                  color: txtColor.withOpacity(0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        VoxCard(
                          titleTxt: "Pet Name: ",
                          voxTxt: voxData[index].voxName.toString(),
                        ),
                        VoxCard(
                          titleTxt: "Pet Age: ",
                          voxTxt: voxData[index].voxAge.toString(),
                        ),
                        VoxCard(
                          titleTxt: "Location: ",
                          voxTxt: voxData[index].voxLoc.toString(),
                        ),
                        Row(
                          children: [
                            Text(
                              "Info: ",
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                color: logoColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                voxData[index].voxInfo.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.fredoka(
                                  fontSize: 15,
                                  color: txtColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Image.asset("assets/images/voxxie_logo.png"),
        ),
      );
    }
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: btnColor,
      centerTitle: true,
      title: SizedBox(
        height: 100,
        child: Image.asset('assets/images/voxxie_logo.png'),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ProfileCubit(),
                  child: const ProfilePage(),
                ),
              ),
            );
          },
          icon: const Icon(Icons.person_2),
        ),
      ],
    );
  }
}
