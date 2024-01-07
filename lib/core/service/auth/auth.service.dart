// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/auth/IAuth.service.dart';

class AuthServices implements IAuthService {
  @override
  Future<Either<String, Unit>> loginUser() {
    // todo: implement loginUser
    throw UnimplementedError();
  }

  @override
  Future<Either<String, Unit>?> registerUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    // todo: implement registerUser
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Weak password!',
        );
      } else if (e.code == 'email-already-in-use') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Email already in use!',
        );
      }
    } catch (err) {
      return left(throw UnimplementedError());
    }
    return null;
  }

  @override
  Future<Either<String, Unit>> setUserData(
    String email,
    String userName,
    BuildContext context,
  ) async {
    // todo: implement setUserData
    try {
      final usersPath = FirebaseFirestore.instance.collection('Users').doc();
      final setInfo = await usersPath.set({
        'userMail': email,
        'userName': userName,
      });
      return right(unit);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }
}
