// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/vox/Vox.service.dart';
import 'package:voxxie/model/voxxie/vox.model.dart';

class VoxxieCubit extends Cubit<VoxxieState> {
  final VoxService voxService = VoxService();
  VoxxieCubit() : super(VoxxieInitial());

  setVoxPost(
    VoxModel model,
    BuildContext context,
  ) async {
    try {
      final service = await voxService.postVox(model);

      if (service.isRight()) {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Post shared',
        );
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Something went wrong!',
        );
      }
    } catch (err) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: '$err',
      );
    }
  }

  updateVox(
    VoxModel model,
    BuildContext context,
  ) async {
    try {
      final service = await voxService.updateVox(model);

      if (service.isRight()) {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Post updated',
        );
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Something went wrong!',
        );
      }
    } catch (err) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: '$err',
      );
    }
  }

  getAllVox() async {
    emit(VoxxieLoadingState());
    try {
      final services = await voxService.getAllVox();
      if (services.isRight()) {
        final dynamicList = services.getOrElse(() => []);
        final productList =
            dynamicList.map((data) => VoxModel.fromMap(data)).toList();
        emit(VoxxieLoadedState(productList));
        return productList;
      }
    } catch (err) {
      return throw UnimplementedError();
    }
  }
}

abstract class VoxxieState {}

class VoxxieInitial extends VoxxieState {}

class VoxxieLoadingState extends VoxxieState {}

class VoxxieLoadedState extends VoxxieState {
  final List<VoxModel> allProduct;

  VoxxieLoadedState(this.allProduct);
}

class VoxxieErrorState extends VoxxieState {}
