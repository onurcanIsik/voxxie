// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/auth/auth.service.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/core/shared/shared_manager.dart';
import 'package:voxxie/core/util/enums/shared_keys.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:voxxie/main.dart';
import 'package:voxxie/pages/auth/login.dart';
import 'package:voxxie/pages/home/nav/navbar.dart';

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
      final checkUserName = SharedManager.getString(SharedKeys.userName);
      final service = await _authServices.loginUser(
        email,
        password,
        context,
      );

      if (service.isRight()) {
        if (checkUserName!.isEmpty) {
          Navigator.of(context)
              .pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
                (route) => false,
              )
              .then(
                (value) => QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                ),
              );
        }
        return Navigator.of(context)
            .pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const NavbarPage(),
              ),
              (route) => false,
            )
            .then(
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
        userName,
      );
      if (service!.isRight()) {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
        ).then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => AuthCubit(),
                child: LoginPage(),
              ),
            ),
          );
        });
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
