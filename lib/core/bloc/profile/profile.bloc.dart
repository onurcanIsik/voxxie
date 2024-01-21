// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/core/service/profile/profile.service.dart';
import 'package:voxxie/model/user/user.model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService profileService = ProfileService();
  ProfileCubit() : super(ProfileInitial());

  Future<List<UserModel>?> getUserInfo(String uuid) async {
    emit(ProfileLoadingState());
    try {
      final services = await profileService.getUserInfo(uuid);

      if (services.isRight()) {
        final dynamicList = services.getOrElse(() => []);
        final productList =
            dynamicList.map((data) => UserModel.fromMap(data)).toList();
        emit(ProfileLoadedState(productList));
        return productList;
      }
    } catch (err) {
      return throw UnimplementedError();
    }
    return null;
  }

  deleteUserProduct(String productID, BuildContext context) async {
    try {
      final service = await profileService.deleteUserPost(productID);

      if (service.isRight()) {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Product deleted',
        );
      } else {
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Try again later !',
        );
      }
    } catch (e) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Something went wrong!',
      );
    }
  }
}

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final List<UserModel> datas;

  ProfileLoadedState(this.datas);
}

class ProfileErrorState extends ProfileState {}
