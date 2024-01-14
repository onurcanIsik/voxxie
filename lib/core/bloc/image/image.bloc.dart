// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/image/Image.service.dart';

class ImageCubit extends Cubit<ImageState> {
  final ImageService imageService = ImageService();
  ImageCubit() : super(ImageInitial());

  setUserImage(BuildContext context) async {
    try {
      final service = await imageService.getImage();

      if (service.isRight()) {
        return QuickAlert.show(context: context, type: QuickAlertType.success);
      }
    } catch (err) {
      return QuickAlert.show(context: context, type: QuickAlertType.error);
    }
  }
}

abstract class ImageState {}

class ImageInitial extends ImageState {}
