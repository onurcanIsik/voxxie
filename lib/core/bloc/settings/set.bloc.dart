// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/settings/settings.service.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService settingsService = SettingsService();
  SettingsCubit() : super(SettingsInitial());

  updateName(
    String newName,
    BuildContext context,
  ) async {
    try {
      final service = await settingsService.changeUsername(newName);

      if (service.isRight()) {
        return QuickAlert.show(context: context, type: QuickAlertType.success);
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: LocaleKeys.handle_texts_something_wrong_text.locale,
        );
      }
    } catch (e) {
      return QuickAlert.show(context: context, type: QuickAlertType.error);
    }
  }

  updateMail(
    String newMail,
    BuildContext context,
  ) async {
    try {
      final service = await settingsService.changeEmail(newMail);

      if (service.isRight()) {
        return QuickAlert.show(context: context, type: QuickAlertType.success);
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: LocaleKeys.handle_texts_something_wrong_text.locale,
        );
      }
    } catch (e) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: LocaleKeys.handle_texts_something_wrong_text.locale,
      );
    }
  }

  updatePassword(
    String newPassword,
    String currentPassword,
    BuildContext context,
  ) async {
    try {
      final service = await settingsService.changePassword(
        newPassword,
        currentPassword,
      );
      if (service.isRight()) {
        return QuickAlert.show(context: context, type: QuickAlertType.success);
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: LocaleKeys.handle_texts_something_wrong_text.locale,
        );
      }
    } catch (err) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: LocaleKeys.handle_texts_something_wrong_text.locale,
      );
    }
  }
}

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}
