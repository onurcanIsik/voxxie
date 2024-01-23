// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/auth/IAuth.service.dart';

class AuthServices implements IAuthService {
  var instance = FirebaseFirestore.instance;
  @override
  Future<Either<String, UserCredential>> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final loginUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return right(loginUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'User not found !',
        );
        return left('User not found');
      } else if (e.code == 'wrong-password') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Wrong password provided for that user.',
        );
        return left('Wrong password');
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'An unexpected error occurred.',
        );
        return left('Unexpected error');
      }
    }
  }

  @override
  Future<Either<String, Unit>?> registerUser(
    String email,
    String password,
    BuildContext context,
    String userName,
  ) async {
    // todo: implement registerUser
    try {
      final checkUser = await instance
          .collection("Users")
          .where('userName', isEqualTo: userName)
          .get();

      if (checkUser.docs.isEmpty) {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await setUserData(email, userName, context);
        return right(unit);
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'This username already in use!',
        );
        return left('This username already in use!');
      }
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
      final userID = FirebaseAuth.instance.currentUser!.uid;
      final usersPath =
          FirebaseFirestore.instance.collection('Users').doc(userID);
      final setInfo = await usersPath.set({
        'userMail': email,
        'userName': userName,
        'userID': userID,
      });
      return right(unit);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }
}
