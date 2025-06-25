import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void ShowSnackBar(BuildContext context, String message, {Color bgColor = Colors.black}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16.sp, // Use .sp for font size
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color
          ),
        ),
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16.w), // Use .w for margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r), // Use .r for radius
      ),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}