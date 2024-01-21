// ignore_for_file: unused_local_variable, use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/vox/vox.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/components/auth/txt_form.widget.dart';
import 'package:voxxie/model/voxxie/vox.model.dart';

class AddVoxxiePage extends StatefulWidget {
  const AddVoxxiePage({super.key});

  @override
  State<AddVoxxiePage> createState() => _AddVoxxiePageState();
}

class _AddVoxxiePageState extends State<AddVoxxiePage> {
  final TextEditingController voxName = TextEditingController();
  final TextEditingController voxGenus = TextEditingController();
  final TextEditingController voxAge = TextEditingController();
  final TextEditingController voxColor = TextEditingController();
  final TextEditingController voxInfo = TextEditingController();
  final TextEditingController voxLoc = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? image = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                      image: image!.isEmpty
                          ? null
                          : DecorationImage(
                              image: NetworkImage(image!),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: Center(
                      child: isLoading == true
                          ? const CircularProgressIndicator()
                          : image!.isEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    await selectImage(context);
                                    setState(() {});
                                  },
                                )
                              : null,
                    ),
                  ),
                ),
              ),
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
                btnText: "Post",
                btnWidth: 150,
                btnFunc: () async {
                  DateTime now = DateTime.now();
                  final String formattedDateTime =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                  if (formKey.currentState!.validate()) {
                    await context.read<VoxxieCubit>().setVoxPost(
                          VoxModel(
                            voxName: voxName.text,
                            voxGen: voxGenus.text,
                            voxAge: voxAge.text,
                            voxColor: voxColor.text,
                            voxLoc: voxLoc.text,
                            voxInfo: voxInfo.text,
                            voxImage: image,
                            date: formattedDateTime,
                            ownerMail: FirebaseAuth.instance.currentUser!.email,
                          ),
                          context,
                        );
                    voxName.clear();
                    voxGenus.clear();
                    voxColor.clear();
                    voxAge.clear();
                    voxLoc.clear();
                    voxInfo.clear();

                    setState(() {
                      image = "";
                    });
                  }
                },
              ),
              const SizedBox(height: 40)
            ],
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
        'Add Voxx',
        style: GoogleFonts.fredoka(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );
  }

  final ImagePicker _imagePicker = ImagePicker();

  final userID = FirebaseAuth.instance.currentUser!.uid;

  selectImage(BuildContext context) async {
    try {
      final XFile? pickedImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final File imageFile = File(pickedImage.path);
        final imageUrl = await getImage(imageFile, context);

        return image = imageUrl;
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Someting went wrong',
        );
      }
    } catch (err) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: '$err',
      );
    }
  }

  getImage(File imageFile, BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('voxx/${DateTime.now().millisecondsSinceEpoch.toString()}');

      await storageReference.putFile(imageFile);
      final String imageUrl = await storageReference.getDownloadURL();
      setState(() {
        isLoading = false;
        image = imageUrl;
      });
      return imageUrl;
    } catch (e) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: '$e',
      );
    }
  }
}
