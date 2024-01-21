import 'package:dartz/dartz.dart';
import 'package:voxxie/model/voxxie/vox.model.dart';

abstract class IVoxService {
  Future<Either<String, Unit>> postVox(VoxModel model);
  Future<Either<String, Unit>> updateVox(VoxModel model);
  Future<Either<String, List>> getAllVox();
}
