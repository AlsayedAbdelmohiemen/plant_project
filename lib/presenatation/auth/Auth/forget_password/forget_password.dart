import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ✅ إضافة الترجمة
import '../auth_service..dart';
import '../components/custom_bottom.dart';
import '../Login/login.dart';
import '../components/text_form_filed.dart';
import 'opt_page.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = 'ForgetPasswordPage';

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void verifyEmail() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final email = emailController.text.trim();
      try {
        final response = await AuthService.forgetPassword(email);
        if (response['success'] == true) {
          Navigator.pushNamed(
            context,
            OtpPage.routeName,
            arguments: email,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.otpFailed)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${AppLocalizations.of(context)!.errorOccurred}: $e")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  localizations.forgotPasswordTitle,
                  style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 16.h),
                Text(
                  localizations.forgotPasswordMessage,
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
                SizedBox(height: 20.h),
                Text(
                  localizations.email,
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.emailRequired;
                    }
                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                      return localizations.enterValidEmail;
                    }
                    return null;
                  },
                  hintText: localizations.enterYourEmail,
                  my_controller: emailController,
                ),
                SizedBox(height: 30.h),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                  title: localizations.verifyEmail,
                  onPressed: verifyEmail,
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.rememberPassword,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, LoginPage.routeName),
                      child: Text(
                        localizations.login,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
