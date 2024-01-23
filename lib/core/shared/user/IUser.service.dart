import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class IUserService {
  Future<Either<String, Unit>> saveUserData(
    String userNameValue,
    String userImageValue,
    String userMailValue,
    BuildContext context,
  );
}
