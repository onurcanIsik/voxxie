import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voxxie/core/service/ivox/MyIvox.service.dart';

class MyVoxService implements MyIVoxService {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Future<Either<String, List>> getMyVox() async {
    // todo: implement getMyVox

    try {
      final myVox = FirebaseFirestore.instance
          .collection('Voxx')
          .where('userID', isEqualTo: userID);
      QuerySnapshot voxxie = await myVox.get();
      final allData = voxxie.docs.map((doc) => doc.data()).toList();
      return right(allData);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }
}
