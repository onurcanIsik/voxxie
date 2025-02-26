// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers

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
    final user = FirebaseAuth.instance.currentUser;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    try {
      final user = _auth.currentUser;
      await user!.updateEmail(newMail);
      await user.sendEmailVerification();
      await users.doc(user.uid).update({'userMail': newMail});
      await AuthManager().setVerifiedIn(false);

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

  @override
  Future<Either<String, Unit>> changePassword(
    String newPassword,
    String currentPassword,
  ) async {
    // todo: implement changePassword
    try {
      final user = FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      return right(unit);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }
}
