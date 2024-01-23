import 'package:equatable/equatable.dart';

class SettinState extends Equatable {
  const SettinState({required this.isDarkTheme});

  const SettinState.copyWith({bool? isDarkTheme})
      : this(isDarkTheme: isDarkTheme ?? false);

  final bool? isDarkTheme;

  @override
  List<Object?> get props => [isDarkTheme];
}
