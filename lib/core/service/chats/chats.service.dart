// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:voxxie/core/service/chats/IChats.service.dart';
import 'package:voxxie/model/chats/chats.model.dart';

class ChatsService implements IChatService {
  @override
  Future<Either<String, Unit>> setChats(ChatsModel model) async {
    final docID = const Uuid().v4();
    // todo: implement setChats
    try {
      final path = FirebaseFirestore.instance.collection("chats").doc(docID);
      final addChats = await path.set({
        'displayImage': model.displayImage,
        'displayName': model.displayName,
        'members': {
          model.userID1,
          model.userID2,
        },
        'docID': docID,
      });
      final addMessages = await path.collection('messages').doc(docID).set({
        'message': model.message,
        'senderID': model.senderID,
        'timestamp': DateTime.now(),
      });

      return right(unit);
    } catch (e) {
      return left(throw UnimplementedError());
    }
  }
}
