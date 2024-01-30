// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voxxie/core/service/reminder/IReminder.service.dart';
import 'package:voxxie/model/reminder/Reminder.model.dart';

class ReminderService implements IReminderService {
  @override
  Future<Either<String, Unit>> deleteReminder(String docID) async {
    // todo: implement deleteReminder
    try {
      final userReminder =
          FirebaseFirestore.instance.collection('Reminder').doc(docID).delete();

      return right(unit);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }

  @override
  Future<Either<String, List>> getUserReminder() async {
    // todo: implement getAllReminder
    try {
      final userReminder = FirebaseFirestore.instance
          .collection('Reminder')
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
      QuerySnapshot voxxie = await userReminder.get();
      final allData = voxxie.docs.map((doc) => doc.data()).toList();
      return right(allData);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }

  @override
  Future<Either<String, Unit>> setReminder(ReminderModel model) async {
    // todo: implement setReminder
    try {
      final path =
          FirebaseFirestore.instance.collection('Reminder').doc(model.docID);
      final setData = await path.set({
        'date': model.date,
        'drugName': model.drugName,
        'petImage': model.petImage,
        'petName': model.petName,
        'docID': model.docID,
        'userID': model.userID,
      });
      return right(unit);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }
}
