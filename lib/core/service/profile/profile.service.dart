import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:voxxie/core/service/profile/IProfile.service.dart';

class ProfileService implements IProfileService {
  @override
  Future<Either<String, List>> getUserInfo(String uuid) async {
    // todo: implement getUserInfo
    try {
      final usersInfo = FirebaseFirestore.instance
          .collection('Users')
          .where('userID', isEqualTo: uuid);

      QuerySnapshot querySnapshot = await usersInfo.get();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return right(allData);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }
}
