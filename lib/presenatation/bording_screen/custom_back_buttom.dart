import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  CustomBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30.w,  // Use .w for width
        height: 30.h, // Use .h for height
        decoration: BoxDecoration(
          color: Colors.transparent,  // Make the background transparent
          shape: BoxShape.circle,  // Circle shape for the button
          border: Border.all(
            color: Theme.of(context).primaryColor,  // Add a colored border to represent the button's outer edge
            width: 2.w,  // Adjust the border thickness using .w
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,  // You can also use Icons.arrow_back_ios if needed
            color: Theme.of(context).primaryColor, // Color of the arrow (same as the border color)
            size: 18.sp,  // Use .sp for icon size
          ),
        ),
      ),
    );
  }
}