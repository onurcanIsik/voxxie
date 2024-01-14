// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:voxxie/core/service/vox/IVox.service.dart';
import 'package:voxxie/model/voxxie/vox.model.dart';

class VoxService implements IVoxService {
  final randID = const Uuid().v4();
  final userID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Future<Either<String, Unit>> postVox(VoxModel model) async {
    // todo: implement postVox

    try {
      final voxPath = FirebaseFirestore.instance.collection("Voxx");
      final setVox = await voxPath.doc(randID).set({
        'voxName': model.voxName,
        'voxAge': model.voxAge,
        'voxColor': model.voxColor,
        'voxGen': model.voxGen,
        'voxInfo': model.voxInfo,
        'voxLoc': model.voxLoc,
        'voxID': userID,
        'voxImage': model.voxImage,
        'voxDate': model.date,
      });
      return right(unit);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }

  @override
  Future<Either<String, List>> getAllVox() async {
    // todo: implement getAllVox
    try {
      final path = FirebaseFirestore.instance.collection('Voxx').orderBy(
            'voxDate',
            descending: true,
          );

      QuerySnapshot voxxie = await path.get();
      final allData = voxxie.docs.map((doc) => doc.data()).toList();
      return right(allData);
    } catch (handle) {
      return left(throw UnimplementedError());
    }
  }
}
