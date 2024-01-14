import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class IAuthService {
  Future<Either<String, Unit>?> registerUser(
    String email,
    String password,
    BuildContext context,
  );
  Future<Either<String, UserCredential>> loginUser(
    String email,
    String password,
    BuildContext context,
  );
  Future<Either<String, Unit>> setUserData(
    String email,
    String userName,
    BuildContext context,
  );
}
