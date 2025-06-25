// theme_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final bool isDarkMode;

  ThemeState({required this.isDarkMode});
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(isDarkMode: false));

  void toggleTheme() {
    emit(ThemeState(isDarkMode: !state.isDarkMode));
  }
}