// ignore_for_file: unused_local_variable

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:voxxie/core/util/enums/shared_keys.dart';
import 'package:voxxie/core/shared/shared_manager.dart';
import 'package:voxxie/core/shared/user/IUser.service.dart';

class UserService implements IUserService {
  @override
  Future<Either<String, Unit>> saveUserData(
    String userNameValue,
    String userImageValue,
    String userMailValue,
    BuildContext context,
  ) async {
    // todo: implement saveUserData
    try {
      final setUserName =
          await SharedManager.setString(SharedKeys.userName, userNameValue);
      final setUserImage =
          await SharedManager.setString(SharedKeys.userImage, userImageValue);
      final setUserMail =
          await SharedManager.setString(SharedKeys.userMail, userMailValue);
      return right(unit);
    } catch (err) {
      return left(throw UnimplementedError());
    }
  }
}
