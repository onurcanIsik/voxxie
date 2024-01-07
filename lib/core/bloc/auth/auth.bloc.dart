// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/auth/auth.service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthServices _authServices = AuthServices();
  final formKey = GlobalKey<FormState>();
  AuthCubit() : super(AuthInitial());

  setUserInfo(
    String email,
    String userName,
    BuildContext context,
  ) async {
    try {
      final service = await _authServices.setUserData(
        email,
        userName,
        context,
      );

      if (service.isRight()) {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
        );
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
        );
      }
    } catch (err) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
      );
    }
  }

  userRegister(
    String email,
    String password,
    String userName,
    BuildContext context,
  ) async {
    try {
      final service = await _authServices.registerUser(
        email,
        password,
        context,
      );
      if (service!.isRight()) {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
        );
      }
    } catch (err) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
      );
    }
  }
}

abstract class AuthState {}

class AuthInitial extends AuthState {}
