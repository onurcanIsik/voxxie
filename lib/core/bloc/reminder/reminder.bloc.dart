// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/reminder/Reminder.service.dart';
import 'package:voxxie/model/reminder/Reminder.model.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final ReminderService reminderService = ReminderService();
  ReminderCubit() : super(ReminderInitial());

  setData(
    ReminderModel model,
    BuildContext context,
  ) async {
    try {
      final service = await reminderService.setReminder(model);

      if (service.isRight()) {
        return QuickAlert.show(context: context, type: QuickAlertType.success);
      } else {
        return QuickAlert.show(context: context, type: QuickAlertType.warning);
      }
    } catch (e) {
      return QuickAlert.show(context: context, type: QuickAlertType.error);
    }
  }

  getData(BuildContext context) async {
    try {
      emit(ReminderLoadingState());
      final service = await reminderService.getUserReminder();

      if (service.isRight()) {
        final dynamicList = service.getOrElse(() => []);
        final productList =
            dynamicList.map((data) => ReminderModel.fromMap(data)).toList();
        emit(ReminderLoadedState(productList));
        return productList;
      } else {
        return QuickAlert.show(context: context, type: QuickAlertType.warning);
      }
    } catch (e) {
      return QuickAlert.show(context: context, type: QuickAlertType.error);
    }
  }

  deleteData(String docID, BuildContext context) async {
    try {
      final service = await reminderService.deleteReminder(docID);

      if (service.isRight()) {
        return QuickAlert.show(context: context, type: QuickAlertType.success);
      } else {
        return QuickAlert.show(context: context, type: QuickAlertType.warning);
      }
    } catch (e) {
      return QuickAlert.show(context: context, type: QuickAlertType.error);
    }
  }
}

abstract class ReminderState {}

class ReminderInitial extends ReminderState {}

class ReminderLoadingState extends ReminderState {}

class ReminderLoadedState extends ReminderState {
  final List<ReminderModel> reminderData;

  ReminderLoadedState(this.reminderData);
}

class ReminderErrorState extends ReminderState {}
