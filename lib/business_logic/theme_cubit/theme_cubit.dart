
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/utils/theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.lightTheme) {
    _loadSavedTheme();
  }

  static const String _themeKey = 'isDarkMode';

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    emit(isDark ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  // In your ThemeCubit
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state == AppTheme.darkTheme;
    await prefs.setBool(_themeKey, !isDark);
    emit(isDark ? AppTheme.lightTheme : AppTheme.darkTheme); // This should trigger rebuilds
  }
  bool get isDarkMode => state == AppTheme.darkTheme;
}