import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/settings/set.bloc.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/components/auth/txt_form.widget.dart';
import 'package:voxxie/core/extensions/context.extension.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final TextEditingController controllerOldPassword = TextEditingController();
  final TextEditingController controllerNewPassword = TextEditingController();
  final TextEditingController controllerRepeatPassword =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: btnColor,
        title: Text(
          LocaleKeys.settings_page_change_password_text.locale,
          style: GoogleFonts.fredoka(),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Form _buildBody(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: context.dynamicHeight(0.7),
              width: context.dynamicWidth(0.9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Column(
                  children: [
                    TxtFormWidget(
                      topPad: 150,
                      hintTxt:
                          LocaleKeys.settings_page_old_password_text.locale,
                      controller: controllerOldPassword,
                      validatorTxt: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys
                              .handle_texts_cannot_blank_text.locale;
                        }
                        return null;
                      },
                      isVisible: true,
                      isObscure: true,
                    ),
                    TxtFormWidget(
                      topPad: 10,
                      hintTxt:
                          LocaleKeys.settings_page_new_password_text.locale,
                      controller: controllerNewPassword,
                      validatorTxt: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys
                              .handle_texts_cannot_blank_text.locale;
                        }
                        return null;
                      },
                      isVisible: true,
                      isObscure: true,
                    ),
                    TxtFormWidget(
                      topPad: 10,
                      hintTxt:
                          LocaleKeys.settings_page_repeat_password_text.locale,
                      controller: controllerRepeatPassword,
                      validatorTxt: (value) {
                        return controllerNewPassword.text == value
                            ? null
                            : LocaleKeys
                                .handle_texts_handle_old_password_text.locale;
                      },
                      isVisible: true,
                      isObscure: true,
                    ),
                    BtnWidget(
                      topPdng: 30,
                      btnHeight: 40,
                      btnText: LocaleKeys.settings_page_show_btn_text.locale,
                      btnWidth: 100,
                      btnFunc: () {
                        if (formKey.currentState!.validate()) {
                          context.read<SettingsCubit>().updatePassword(
                                controllerNewPassword.text,
                                controllerOldPassword.text,
                                context,
                              );
                          controllerNewPassword.clear();
                          controllerOldPassword.clear();
                          controllerRepeatPassword.clear();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
