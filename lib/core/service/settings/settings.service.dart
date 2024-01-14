// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voxxie/core/service/manager/authManager.dart';
import 'package:voxxie/core/service/settings/ISettings.service.dart';

class SettingsService implements ISettingsService {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Future<Either<String, Unit>> changeEmail(String newMail) async {
    // todo: implement changeEmail

    try {
      final emailPath = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userID)
          .update({
        'userMail': newMail,
      }).then((value) {
        AuthManager().setVerifiedIn(false);
      });

      return right(unit);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }

  @override
  Future<Either<String, Unit>> changeUsername(String newName) async {
    // todo: implement changeUsername
    try {
      final emailPath = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userID)
          .update({
        'userName': newName,
      });

      return right(unit);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }
}
