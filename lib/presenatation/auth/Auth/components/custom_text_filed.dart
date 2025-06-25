import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData suffixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.suffixIcon,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h, // Use .h for height
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.r), // Use .r for radius
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black45,
            fontSize: 16.sp, // Use .sp for font size
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h), // Use .w and .h for padding
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 10.w), // Use .w for padding
            child: Icon(
              suffixIcon,
              color: Colors.black54,
              size: 24.w, // Use .w for icon size
            ),
          ),
        ),
      ),
    );
  }
}