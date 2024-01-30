// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/reminder/reminder.bloc.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/components/reminder/reminder_txt.widget.dart';
import 'package:voxxie/core/extensions/context.extension.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:voxxie/model/reminder/Reminder.model.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final TextEditingController drugNameController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? image = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return Scaffold(
      appBar: _appBar(),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: context.paddingAllLow * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: context.dynamicHeight(0.2),
                    width: context.dynamicWidth(0.32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkTheme ? lightOrangeColor : darkBgColor,
                      ),
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
                  Padding(
                    padding: context.paddingAllLow * 0.7,
                    child: Column(
                      children: [
                        ReminderWidget(
                          controller: drugNameController,
                          hintTxt: LocaleKeys
                              .reminder_page_texts_pet_drug_name_text.locale,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return LocaleKeys
                                  .handle_texts_cannot_blank_text.locale;
                            }
                            return null;
                          },
                        ),
                        ReminderWidget(
                          controller: petNameController,
                          hintTxt: LocaleKeys
                              .reminder_page_texts_pet_name_text.locale,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return LocaleKeys
                                  .handle_texts_cannot_blank_text.locale;
                            }
                            return null;
                          },
                        ),
                        ReminderWidget(
                          controller: dateController,
                          readOnly: true,
                          iconWidget: const Icon(Icons.calendar_month),
                          hintTxt: LocaleKeys
                              .reminder_page_texts_pet_add_date_text.locale,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return LocaleKeys
                                  .handle_texts_cannot_blank_text.locale;
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(() {
                                dateController.text = formattedDate;
                              });
                            } else {}
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            BtnWidget(
              topPdng: 15,
              btnHeight: 50,
              btnText: LocaleKeys.add_vox_page_add_vox_button_text.locale,
              btnWidth: 100,
              btnFunc: () {
                final docID = const Uuid().v4();
                if (formKey.currentState!.validate() && image!.isNotEmpty) {
                  context.read<ReminderCubit>().setData(
                        ReminderModel(
                          date: dateController.text,
                          drugName: drugNameController.text,
                          petImage: image,
                          petName: petNameController.text,
                          docID: docID,
                          userID: userID,
                        ),
                        context,
                      );
                  setState(() {
                    dateController.clear();
                    petNameController.clear();
                    drugNameController.clear();
                    image = '';
                  });
                  context.read<ReminderCubit>().getData(context);
                }
              },
            ),
            Padding(
              padding: context.paddingAllLow * 1.2,
              child: Divider(
                height: 3,
                thickness: 1,
                color: isDarkTheme ? lightBgColor : darkBgColor,
              ),
            ),
            BlocBuilder<ReminderCubit, ReminderState>(
              builder: (context, state) {
                if (state is ReminderLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ReminderLoadedState) {
                  final data = state.reminderData;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: isDarkTheme ? lightBgColor : darkBgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              data[index].petName.toString(),
                              style: GoogleFonts.fredoka(
                                color: isDarkTheme ? darkBgColor : lightBgColor,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                data[index].petImage.toString(),
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data[index].drugName.toString(),
                                  style: GoogleFonts.fredoka(
                                    color: isDarkTheme
                                        ? darkBgColor
                                        : lightBgColor,
                                  ),
                                ),
                                Text(
                                  data[index].date.toString(),
                                  style: GoogleFonts.fredoka(
                                    color: isDarkTheme
                                        ? darkBgColor
                                        : lightBgColor,
                                  ),
                                )
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  context.read<ReminderCubit>().deleteData(
                                        data[index].docID.toString(),
                                        context,
                                      );
                                  context
                                      .read<ReminderCubit>()
                                      .getData(context);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center();
              },
            )
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 10,
      backgroundColor: darkAppbarColorColor,
      title: Text(LocaleKeys.reminder_page_texts_appbar_text.locale),
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
      final Reference storageReference = FirebaseStorage.instance.ref().child(
          'reminder/${DateTime.now().millisecondsSinceEpoch.toString()}');

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
