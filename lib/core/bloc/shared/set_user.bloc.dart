// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxxie/core/shared/user/User.service.dart';

class SharedUserCubit extends Cubit<SharedUserState> {
  final UserService userService = UserService();
  SharedUserCubit() : super(SharedUserInitial());

  setUserData(
    String userNameValue,
    String userImageValue,
    String userMailValue,
    BuildContext context,
  ) async {
    try {
      final service = await userService.saveUserData(
        userNameValue,
        userImageValue,
        userMailValue,
        context,
      );
      if (service.isRight()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Your data updated successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Your data not been updated'),
          ),
        );
      }
    } catch (err) {
      return;
    }
  }
}

abstract class SharedUserState {}

class SharedUserInitial extends SharedUserState {}
