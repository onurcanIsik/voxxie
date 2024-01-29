// ignore_for_file: unused_element, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/components/auth/txt_form.widget.dart';
import 'package:voxxie/core/extensions/context.extension.dart';
import 'package:voxxie/core/shared/shared_manager.dart';
import 'package:voxxie/core/util/enums/shared_keys.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:path/path.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  File? selectedImage;
  String img = '';
  List<String>? drugName;
  List<String>? drugDate;
  List<String> petData = [];
  List<String> petDrugName = [];
  List<String>? petName = [];
  List<String> petDrugDate = [];
  List<String>? imagePaths;
  final TextEditingController drugNameController = TextEditingController();
  final TextEditingController dateInputController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  final formKeyy = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPetData();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            topCards(context),
            Divider(
              height: 3,
              thickness: 3,
              color: isDarkTheme ? bgColor : txtColor,
            ),
            bottomCard(context)
          ],
        ),
      ),
    );
  }

  Padding bottomCard(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return Padding(
      padding: context.paddingAllLow * 0.7,
      child: Container(
        height: context.dynamicHeight(0.6),
        decoration: BoxDecoration(
          color: isDarkTheme ? postBgColor : txtColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: drugDate!.isNotEmpty && drugName!.isNotEmpty
            ? ListView.builder(
                itemCount: drugName!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: FileImage(
                          File(
                            imagePaths![index],
                          ),
                        ),
                      ),
                      title: Text(
                        drugName![index],
                      ),
                      subtitle: Text(
                        drugDate![index],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            deleteItem(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              )
            : imagePaths!.isNotEmpty
                ? Center(
                    child: Text(
                      LocaleKeys.reminder_page_texts_pet_dialog_text.locale,
                      style: GoogleFonts.fredoka(
                        color: isDarkTheme ? bgColor : bgColor,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      LocaleKeys.reminder_page_texts_pet_dialog_2_text.locale,
                      style: GoogleFonts.fredoka(
                        color: isDarkTheme ? bgColor : bgColor,
                      ),
                    ),
                  ),
      ),
    );
  }

  SizedBox topCards(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;

    return SizedBox(
      height: context.dynamicHeight(0.2),
      child: ListView.builder(
        itemCount: 1 + imagePaths!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == imagePaths!.length) {
            return Padding(
              padding: context.paddingAllLow * 1.2,
              child: DottedBorder(
                color: isDarkTheme ? bgColor : txtColor,
                strokeWidth: 1,
                borderType: BorderType.RRect,
                dashPattern: const [7, 7],
                radius: const Radius.circular(12),
                child: Container(
                  width: context.dynamicWidth(0.3),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? postBgColor : txtColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: bgColor,
                      ),
                      onPressed: () async {
                        await pickImage();
                      },
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Padding(
              padding: context.paddingAllLow * 1.2,
              child: GestureDetector(
                onTap: () {
                  selectedDate(
                    context,
                    drugNameController,
                    dateInputController,
                    petNameController,
                    formKeyy,
                  );
                },
                child: Container(
                  width: context.dynamicWidth(0.3),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? postBgColor : txtColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkTheme ? bgColor : txtColor,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(
                        imagePaths![index],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> selectedDate(
    BuildContext context,
    TextEditingController drugNameController,
    TextEditingController dateInput,
    TextEditingController pettName,
    GlobalKey<FormState> formKey,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: context.dynamicHeight(0.8),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TxtFormWidget(
                  topPad: 40,
                  hintTxt:
                      LocaleKeys.reminder_page_texts_pet_drug_name_text.locale,
                  controller: drugNameController,
                  validatorTxt: (value) {
                    if (value!.isEmpty) {
                      return LocaleKeys.handle_texts_cannot_blank_text.locale;
                    }
                    return null;
                  },
                  isVisible: false,
                  isObscure: false,
                ),
                TxtFormWidget(
                  topPad: 40,
                  hintTxt: LocaleKeys.reminder_page_texts_pet_name_text.locale,
                  controller: petNameController,
                  validatorTxt: (value) {
                    if (value!.isEmpty) {
                      return LocaleKeys.handle_texts_cannot_blank_text.locale;
                    }
                    return null;
                  },
                  isVisible: false,
                  isObscure: false,
                ),
                Padding(
                  padding: context.paddingAllLow * 2,
                  child: TextField(
                    controller: dateInput,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.calendar_today),
                      labelText: LocaleKeys
                          .reminder_page_texts_pet_add_date_text.locale,
                      labelStyle: GoogleFonts.fredoka(),
                    ),
                    readOnly: true,
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
                          dateInput.text = formattedDate;
                        });
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BtnWidget(
                      topPdng: 10,
                      btnHeight: 50,
                      btnText: LocaleKeys
                          .reminder_page_texts_pet_save_Data_text.locale,
                      btnWidth: 100,
                      btnFunc: () {
                        setState(() {
                          if (formKey.currentState!.validate() &&
                              dateInput.text.isNotEmpty) {
                            drugDate!.add(dateInput.text);
                            drugName!.add(drugNameController.text);
                            petName!.add(pettName.text);
                            savePetInfo(drugName!, drugDate!, petName!);
                            Navigator.pop(context);
                          }

                          loadPetData();
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: btnColor,
      title: Text(LocaleKeys.reminder_page_texts_appbar_text.locale),
    );
  }

  pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await saveImage(imageFile);
      setState(() {
        img = imageFile.path;
        if (img.isNotEmpty) {
          petData.add(img);
          imagePaths!.add(img);
          savePetData(petData);
          saveImagePaths(imagePaths!);
          loadPetData();
        } else {
          img = '';
        }
      });
    }
  }

  saveImagePaths(List<String> imagePaths) async {
    SharedManager.setStringList(SharedKeys.petImagePaths, imagePaths);
  }

  Future<void> loadPetData() async {
    setState(() {
      petData = SharedManager.getStringList(SharedKeys.petImage) ?? [];
      drugName = SharedManager.getStringList(SharedKeys.petDrugName) ?? [];
      drugDate = SharedManager.getStringList(SharedKeys.petDrugDate) ?? [];
      imagePaths = SharedManager.getStringList(SharedKeys.petImagePaths) ?? [];
    });
  }

  Future<void> savePetData(List<String> data) async {
    SharedManager.setStringList(SharedKeys.petImage, data);
  }

  Future<void> savePetInfo(
    List<String> drugName,
    List<String> drugDate,
    List<String> petName,
  ) async {
    SharedManager.setStringList(SharedKeys.petDrugName, drugName);
    SharedManager.setStringList(SharedKeys.petDrugDate, drugDate);
    SharedManager.setStringList(SharedKeys.petName, petName);
  }

  saveImage(File imageFile) async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final imagePath = join(appDocumentsDirectory.path,
        '${DateTime.now().millisecondsSinceEpoch}.png');
    await imageFile.copy(imagePath);
    return imagePath;
  }

  deleteItem(int index) {
    setState(() {
      if (drugDate != null &&
          drugName != null &&
          petName != null &&
          index >= 0 &&
          index < drugDate!.length) {
        drugDate!.removeAt(index);
        drugName!.removeAt(index);
        petName!.removeAt(index);

        savePetInfo(drugName!, drugDate!, petName!);

        loadPetData();
      }
    });
  }
}
