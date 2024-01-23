// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/image/image.bloc.dart';
import 'package:voxxie/core/bloc/ivox/ivox.bloc.dart';
import 'package:voxxie/core/bloc/profile/profile.bloc.dart';
import 'package:voxxie/core/bloc/vox/vox.bloc.dart';
import 'package:voxxie/main.dart';
import 'package:voxxie/pages/home/nav/navbar.dart';
import 'package:voxxie/pages/home/vox/update/update_vox.dart';

class UserInfoWidget extends StatefulWidget {
  final String userName;
  final String? userImage;
  final String? userPostCount;

  const UserInfoWidget({
    super.key,
    required this.userName,
    required this.userImage,
    required this.userPostCount,
  });

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>.value(
      value: BlocProvider.of<ProfileCubit>(context),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30),
                child: widget.userImage!.isNotEmpty
                    ? Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: txtColor,
                          image: DecorationImage(
                            image: NetworkImage(widget.userImage!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 0.3,
                              spreadRadius: 0.4,
                              color: Colors.black54,
                              offset: Offset(3, 2),
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                          ),
                        ),
                      )
                    : Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: txtColor,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 0.3,
                              spreadRadius: 0.4,
                              color: Colors.black54,
                              offset: Offset(3, 2),
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                          ),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.photo,
                              color: bgColor,
                            ),
                            onPressed: () async {
                              await context
                                  .read<ImageCubit>()
                                  .setUserImage(context);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const MyApp(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 30),
                child: Container(
                  height: 120,
                  width: 230,
                  decoration: BoxDecoration(
                    color: txtColor,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 0.3,
                        spreadRadius: 0.4,
                        color: Colors.black54,
                        offset: Offset(3, 2),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                          child: Image.asset(
                            'assets/images/bgImage.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.userName,
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              color: bgColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Post: ",
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  color: bgColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                widget.userPostCount!,
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  color: bgColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Divider(
              thickness: 2,
              height: 3,
              color: btnColor,
            ),
          ),
          BlocBuilder<IVoxxieCubit, IVoxxieState>(
            builder: (context, state) {
              if (state is IVoxxieLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is IVoxxieLoadedState) {
                final ivoxData = state.ivox;

                return Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: ivoxData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(
                              context,
                              ivoxData[index].voxImage.toString(),
                              ivoxData[index].voxInfo.toString(),
                              () async {
                                await context
                                    .read<ProfileCubit>()
                                    .deleteUserProduct(
                                      ivoxData[index].voxID.toString(),
                                      context,
                                    );
                              },
                              ivoxData[index].voxID.toString(),
                              ivoxData[index].voxImage.toString(),
                            );
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: txtColor,
                              image: DecorationImage(
                                image: NetworkImage(
                                  ivoxData[index].voxImage.toString(),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (state is IVoxxieErrorState) {}
              return const Center(
                child: Text('Something went wrong!'),
              );
            },
          )
        ],
      ),
    );
  }

  void _showBottomSheet(
    BuildContext context,
    String img,
    String info,
    Function deleteFunc,
    String voxID,
    String voxImg,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 700,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
              Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      info,
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        color: txtColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          await deleteFunc();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const NavbarPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Delete',
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => VoxxieCubit(),
                                child: UpdateVoxPage(
                                  voxID: voxID,
                                  voxImg: voxImg,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Update',
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
