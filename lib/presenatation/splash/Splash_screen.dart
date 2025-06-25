import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../bording_screen/page_view.dart';
import '../../business_logic/theme_cubit/theme_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), _navigateToOnboarding);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacementNamed(OnboardingPageView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDarkMode
                  ? 'assets/images/Splash_dark.png'
                  : 'assets/images/Splash.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}