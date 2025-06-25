import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController my_controller;
  final String? Function(String?)? validator;
  final IconData? icon;
  final bool isPassword;

  CustomTextFormField({
    this.isPassword = false,
    required this.icon,
    required this.hintText,
    required this.my_controller,
    required this.validator,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.my_controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.isPassword
          ? TextInputType.visiblePassword
          : TextInputType.text,
      style: TextStyle(fontSize: 18.sp), // أصغر حجم للنص المدخل
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 18.sp), // حجم أصغر للنص التوضيحي
        contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.w),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        suffixIcon: widget.isPassword
            ? Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50.r),
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
                size: 18.w, // تصغير حجم الأيقونة
              ),
            ),
          ),
        )
            : (widget.icon != null
            ? Icon(widget.icon, color: Colors.grey, size: 18.w) // تصغير حجم الأيقونة
            : null),
      ),
    );
  }
}