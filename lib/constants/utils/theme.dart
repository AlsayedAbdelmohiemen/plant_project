import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static Color ligthPrimary = const Color(0XFF335540);
  static Color darkPrimary = const Color(0XFF4CAF50);

  // static ThemeMode themeMode  = ThemeMode.dark;

  static ThemeData lightTheme = ThemeData(
    primaryColor: ligthPrimary,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: const Color(0xFFFFFFFF),

    useMaterial3: true,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFFFFFFFF),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(
        color: Color(0XFF335540),
        size: 25,
      ),
      selectedItemColor: Color(0XFF335540),
      selectedLabelStyle: TextStyle(
        color: Color(0XFF335540),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      showSelectedLabels: true,
      unselectedIconTheme: IconThemeData(
        color: Color(0XFF969696),

      ),
    ),
    textTheme:  TextTheme(
      titleLarge: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 18.sp,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        color: Colors.black,
      ),
      headlineSmall: TextStyle(
        fontSize: 16.sp,
        color: Color(0xffA3A3A3),
      ),
    ),

  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: darkPrimary,
    scaffoldBackgroundColor:  Color(0xFF121212),
    canvasColor: const Color(0xFF2C2C2C),


    useMaterial3: true,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 16.sp,
        color: Colors.white,

        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0XFF1A1A1A),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(
        color: Color(0xFF4CAF50),

      ),
      selectedItemColor: Color(0xFF4CAF50),
      selectedLabelStyle: TextStyle(
        color: Color(0xFF4CAF50),

        fontWeight: FontWeight.bold,
      ),
      showSelectedLabels: true,
      unselectedIconTheme: IconThemeData(
        color: Color(0xFF888888),

      ),
    ),
    textTheme:  TextTheme(
      titleLarge: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 18.sp,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 16.sp,
        color: Color(0xffCCCCCC),
      ),
    ),

  );
}
