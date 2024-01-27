import 'package:dartz/dartz.dart';
import 'package:voxxie/model/chats/chats.model.dart';

abstract class IChatService {
  Future<Either<String, Unit>> setChats(ChatsModel model);
}
