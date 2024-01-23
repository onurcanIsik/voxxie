// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/vox/vox.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/components/auth/txt_form.widget.dart';
import 'package:voxxie/model/voxxie/vox.model.dart';

class UpdateVoxPage extends StatefulWidget {
  final String voxID;
  final String voxImg;
  const UpdateVoxPage({
    super.key,
    required this.voxID,
    required this.voxImg,
  });

  @override
  State<UpdateVoxPage> createState() => _UpdateVoxPageState();
}

class _UpdateVoxPageState extends State<UpdateVoxPage> {
  final TextEditingController voxName = TextEditingController();
  final TextEditingController voxGenus = TextEditingController();
  final TextEditingController voxAge = TextEditingController();
  final TextEditingController voxColor = TextEditingController();
  final TextEditingController voxInfo = TextEditingController();
  final TextEditingController voxLoc = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VoxxieCubit(),
      child: Scaffold(
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TxtFormWidget(
                  topPad: 30,
                  hintTxt: "Name",
                  controller: voxName,
                  validatorTxt: (value) {
                    if (value!.isEmpty) {
                      return 'Cannot be blank!';
                    }
                    return null;
                  },
                  isVisible: false,
                  isObscure: false,
                ),
                TxtFormWidget(
                  topPad: 10,
                  hintTxt: "Genus",
                  controller: voxGenus,
                  validatorTxt: (value) {
                    if (value!.isEmpty) {
                      return 'Cannot be blank!';
                    }
                    return null;
                  },
                  isVisible: false,
                  isObscure: false,
                ),
                TxtFormWidget(
                  topPad: 10,
                  hintTxt: "Age",
                  controller: voxAge,
                  validatorTxt: (value) {
                    if (value!.isEmpty) {
                      return 'Cannot be blank!';
                    }
                    return null;
                  },
                  isVisible: false,
                  isObscure: false,
                ),
                TxtFormWidget(
                  topPad: 10,
                  hintTxt: "Color",
                  controller: voxColor,
                  validatorTxt: (value) {
                    if (value!.isEmpty) {
                      return 'Cannot be blank!';
                    }
                    return null;
                  },
                  isVisible: false,
                  isObscure: false,
                ),
                TxtFormWidget(
                  topPad: 10,
                  hintTxt: "Location",
                  controller: voxLoc,
                  validatorTxt: (value) {
                    if (value!.isEmpty) {
                      return 'Cannot be blank!';
                    }
                    return null;
                  },
                  isVisible: false,
                  isObscure: false,
                ),
                TxtFormWidget(
                  topPad: 10,
                  hintTxt: "information about",
                  controller: voxInfo,
                  validatorTxt: (value) {
                    if (value!.isEmpty) {
                      return 'Cannot be blank!';
                    }
                    return null;
                  },
                  isVisible: false,
                  isObscure: false,
                ),
                BtnWidget(
                  topPdng: 30,
                  btnHeight: 50,
                  btnText: "Update",
                  btnWidth: 150,
                  btnFunc: () async {
                    DateTime now = DateTime.now();
                    final String formattedDateTime =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                    if (formKey.currentState!.validate()) {
                      await context.read<VoxxieCubit>().updateVox(
                            VoxModel(
                              voxName: voxName.text,
                              voxGen: voxGenus.text,
                              voxAge: voxAge.text,
                              voxColor: voxColor.text,
                              voxLoc: voxLoc.text,
                              voxInfo: voxInfo.text,
                              voxImage: widget.voxImg,
                              date: formattedDateTime,
                              voxID: widget.voxID,
                            ),
                            context,
                          );
                      voxName.clear();
                      voxGenus.clear();
                      voxColor.clear();
                      voxAge.clear();
                      voxLoc.clear();
                      voxInfo.clear();
                    }
                  },
                ),
                const SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: btnColor,
      title: Text(
        'Update Voxx',
        style: GoogleFonts.fredoka(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );
  }
}
