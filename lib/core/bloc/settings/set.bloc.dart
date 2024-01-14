// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/settings/settings.service.dart';

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
          text: 'Something went wrong! Try again later',
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
          text: 'Something went wrong! Try again later',
        );
      }
    } catch (e) {
      return QuickAlert.show(context: context, type: QuickAlertType.error);
    }
  }
}

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}
