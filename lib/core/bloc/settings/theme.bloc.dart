import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxxie/core/bloc/settings/settings_state.dart';
import 'package:voxxie/core/util/enums/shared_keys.dart';
import 'package:voxxie/core/shared/shared_manager.dart';

class ThemeCubit extends Cubit<SettinState> {
  ThemeCubit()
      : super(
          SettinState(
            isDarkTheme: SharedManager.getBool(SharedKeys.isDarkMode) ?? false,
          ),
        );

  void setLightTheme() {
    SharedManager.setBool(SharedKeys.isDarkMode, false);
    emit(const SettinState.copyWith(isDarkTheme: false));
  }

  void setDarkTheme() {
    SharedManager.setBool(SharedKeys.isDarkMode, true);
    emit(const SettinState.copyWith(isDarkTheme: true));
  }
}
