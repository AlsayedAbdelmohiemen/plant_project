import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constant..dart';
import '../../helper/show_snack_bar.dart';
import '../auth_service..dart';
import '../components/custom_bottom.dart';
import 'reset_password_page.dart';

class OtpPage extends StatefulWidget {
  static const routeName = 'otpPage';

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otpCode = "";
  bool isLoading = false;
  bool canResend = false;
  int remainingTime = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      canResend = false;
      remainingTime = 10;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void verifyOtp() async {
    final local = AppLocalizations.of(context)!;
    if (otpCode.length == 6) {
      setState(() => isLoading = true);
      final email = ModalRoute.of(context)!.settings.arguments as String;

      try {
        final response = await AuthService.verifyOtp(email, otpCode);
        if (response['success'] == true) {
          Navigator.pushReplacementNamed(
            context,
            ResetPasswordPage.routeName,
            arguments: email,
          );
        } else {
          ShowSnackBar(context, response['message'] ?? local.invalidOtp, bgColor: Constants.errorColor);
        }
      } catch (e) {
        ShowSnackBar(context, "${local.errorOccurred}: $e", bgColor: Constants.errorColor);
      } finally {
        setState(() => isLoading = false);
      }
    } else {
      ShowSnackBar(context, local.pleaseEnterSixDigits, bgColor: Constants.errorColor);
    }
  }

  void resendCode() async {
    final local = AppLocalizations.of(context)!;
    if (!canResend || isLoading) return;

    setState(() => isLoading = true);
    final email = ModalRoute.of(context)!.settings.arguments as String;

    try {
      final response = await AuthService.forgetPassword(email);
      if (response['success'] == true) {
        ShowSnackBar(context, local.otpSentSuccess, bgColor: Constants.successColor);
        _startTimer();
      } else {
        ShowSnackBar(context, response['message'] ?? local.invalidOtp, bgColor: Constants.errorColor);
      }
    } catch (e) {
      ShowSnackBar(context, "${local.errorOccurred}: $e", bgColor: Constants.errorColor);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                local.verifyYourIdentity,
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 16.h),
              Text(
                local.otpMessage,
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
              SizedBox(height: 50.h),

              OtpTextField(
                borderRadius: BorderRadius.circular(6.r),
                numberOfFields: 6,
                borderColor: Constants.greenColor,
                showFieldAsBox: true,
                fieldWidth: 40.w,
                textStyle: TextStyle(fontSize: 20.sp),
                onSubmit: (String verificationCode) {
                  setState(() {
                    otpCode = verificationCode;
                  });
                },
              ),

              SizedBox(height: 40.h),
              CustomButton(
                title: local.verifyCode,
                onPressed: isLoading ? null : verifyOtp,
              ),
              SizedBox(height: 40.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    local.didntReceiveCode,
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: (canResend && !isLoading) ? resendCode : null,
                    child: Text(
                      canResend
                          ? local.resendCode
                          : local.resendCodeCountdown(remainingTime), // ✅ هذا هو الشكل الصحيح
                      style: TextStyle(
                        color: canResend ? Theme.of(context).primaryColor : Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                    ),

                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
