import 'dart:io';

import 'package:dartz/dartz.dart';

abstract class IImageService {
  Future<Either<String, Unit>?> getImage();
  Future<Either<String, Unit>> uploadImageToFirestore(File imageFile);
}
