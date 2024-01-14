import 'package:dartz/dartz.dart';

abstract class IProfileService {
  Future<Either<String, List>> getUserInfo(String uuid);
}
