import 'package:dartz/dartz.dart';

abstract class MyIVoxService {
  Future<Either<String, List>> getMyVox();
}
