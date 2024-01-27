// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/chats/chats.service.dart';
import 'package:voxxie/model/chats/chats.model.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatsService chatsService = ChatsService();
  ChatsCubit() : super(ChatsInitial());

  setChats(
    ChatsModel model,
    BuildContext context,
  ) async {
    try {
      final service = await chatsService.setChats(model);

      if (service.isRight()) {
        return QuickAlert.show(context: context, type: QuickAlertType.success);
      } else {
        return QuickAlert.show(context: context, type: QuickAlertType.warning);
      }
    } catch (err) {
      return QuickAlert.show(context: context, type: QuickAlertType.error);
    }
  }
}

abstract class ChatsState {}

class ChatsInitial extends ChatsState {}
