// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/auth/auth.service.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/pages/home/homepage.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthServices _authServices = AuthServices();
  final formKey = GlobalKey<FormState>();
  final AuthManager authManager = AuthManager();

  AuthCubit() : super(AuthInitial());

  loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final service = await _authServices.loginUser(
        email,
        password,
        context,
      );

      if (service.isRight()) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        ).then(
          (value) => QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
          ),
        );
      }
    } catch (err) {
      emit(LoginFailureState("Success fail !"));
    }
  }

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
        return null;
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

class LoginSuccessState extends AuthState {
  final String loginSuccess;

  LoginSuccessState(this.loginSuccess);
}

class LoginFailureState extends AuthState {
  final String isError;

  LoginFailureState(this.isError);
}
