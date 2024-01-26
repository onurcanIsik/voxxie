// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/vox/Vox.service.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
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
          text: LocaleKeys.handle_texts_post_shared_text.locale,
        );
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: LocaleKeys.handle_texts_something_wrong_text.locale,
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
          text: LocaleKeys.handle_texts_post_updated_text.locale,
        );
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: LocaleKeys.handle_texts_something_wrong_text.locale,
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
