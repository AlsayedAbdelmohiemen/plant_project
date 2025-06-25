import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../business_logic/theme_cubit/theme_cubit.dart';
import 'Onboarding_item.dart'; // Ensure this import is correct

class OnboardingScreen extends StatelessWidget {
  final OnboardingItem item;

  OnboardingScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;
    return Scaffold(

      body: Container(
        // Add background image using decoration
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDarkMode
                  ? 'assets/images/on_1_dark.png'
                  : 'assets/images/on_1.png',
            ), // Your background image path
            fit: BoxFit.contain, // Adjust how the image fills the screen
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image at the center with appropriate padding
            // Central image part
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  item.imagePath,
                  width: 0.8.sw, // Adjusted image width using .sw
                  height: 0.4.sh, // Adjusted image height using .sh
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: 20.h), // Adjusted space using .h

            // Title and Subtitle text
            Column(
              children: [
                // Title
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 24.sp, // Maintain responsiveness
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h), // Responsive vertical spacing

// Subtitle
                Padding(
                  padding: EdgeInsets.all(32.r), // Responsive padding
                  child: Text(
                    item.subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp, // Maintain responsiveness

                    ),
                  ),
                ),

              ],
            ),

            Spacer(), // Spacer to push the button to the bottom

            // Forward arrow button at the bottom center
            // You can add your CustomNextButton here if needed
          ],
        ),
      ),
    );
  }
}