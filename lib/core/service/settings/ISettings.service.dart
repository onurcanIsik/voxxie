import 'package:dartz/dartz.dart';

abstract class ISettingsService {
  Future<Either<String, Unit>> changeEmail(String newMail);
  Future<Either<String, Unit>> changeUsername(String newName);
}
