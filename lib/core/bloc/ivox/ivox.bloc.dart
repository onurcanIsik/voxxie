import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxxie/core/service/ivox/MyVox.service.dart';
import 'package:voxxie/model/voxxie/vox.model.dart';

class IVoxxieCubit extends Cubit<IVoxxieState> {
  final MyVoxService myVoxService = MyVoxService();
  IVoxxieCubit() : super(IVoxxieInitial());

  getAllMyVoxxie() async {
    emit(IVoxxieLoadingState());
    try {
      final services = await myVoxService.getMyVox();

      if (services.isRight()) {
        final dynamicList = services.getOrElse(() => []);
        final productList =
            dynamicList.map((data) => VoxModel.fromMap(data)).toList();
        emit(IVoxxieLoadedState(productList));

        return productList;
      }
    } catch (e) {
      emit(IVoxxieErrorState());
    }
  }
}

abstract class IVoxxieState {}

class IVoxxieInitial extends IVoxxieState {}

class IVoxxieLoadingState extends IVoxxieState {}

class IVoxxieLoadedState extends IVoxxieState {
  final List<VoxModel> ivox;

  IVoxxieLoadedState(this.ivox);
}

class IVoxxieErrorState extends IVoxxieState {}
