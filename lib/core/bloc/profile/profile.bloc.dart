import 'package:flutter_bloc/flutter_bloc.dart';
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
}

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final List<UserModel> datas;

  ProfileLoadedState(this.datas);
}

class ProfileErrorState extends ProfileState {}
