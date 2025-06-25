import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../layout/home_layout.dart';
import '../../constant..dart';
import '../../helper/show_snack_bar.dart';
import '../Register/register.dart';
import '../Register/verify_email_page.dart';
import '../auth_service..dart';
import '../components/custom_bottom.dart';
import '../components/text_form_filed.dart';
import '../sharedPrefrence/shared_pref.dart';
import 'deep_link_service.dart';
import '../forget_password/forget_password.dart';
import 'google_auth_service.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool isAutoLoginAttempted = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DeepLinkService.initDeepLinkListener(context);
    _attemptAutoLogin();
  }

  @override
  void dispose() {
    DeepLinkService.disposeDeepLinkListener();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptAutoLogin() async {
    if (isAutoLoginAttempted) return;

    setState(() {
      isLoading = true;
      isAutoLoginAttempted = true;
    });

    try {
      final credentials = await SharedPreference.getLoginCredentials();
      final email = credentials['email'];
      final password = credentials['password'];

      if (email != null && password != null) {
        emailController.text = email;
        final response = await AuthService.login(
          email: email,
          password: password,
        );

        if (response != null && response['success'] == true) {
          await SharedPreference.saveToken(response['token']);
          if (mounted) {
            Navigator.pushReplacementNamed(context, HomeLayout.routeName);
            return;
          }
        }
      }
    } catch (_) {} finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void loginUser() async {
    final local = AppLocalizations.of(context)!;

    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final response = await AuthService.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (response != null && response['success'] == true) {
          await SharedPreference.saveToken(response['token']);
          await SharedPreference.saveLoginCredentials(
              emailController.text.trim(), passwordController.text.trim());

          ShowSnackBar(context, local.loginSuccess, bgColor: Constants.successColor);
          await Future.delayed(const Duration(milliseconds: 1500));
          Navigator.pushReplacementNamed(context, HomeLayout.routeName);
        } else {
          final error = response?['error'] ?? local.loginFailed;

          if (error.contains("invalid credentials")) {
            ShowSnackBar(context, local.invalidCredentials, bgColor: Constants.errorColor);
          } else if (error.contains("User not found")) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(local.userNotFound),
                backgroundColor: Constants.errorColor,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: local.signUp,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RegisterPage.routeName);
                  },
                ),
              ),
            );
          } else if (error.contains("not verified")) {
            ShowSnackBar(context, local.notVerified, bgColor: Constants.errorColor);
            Navigator.pushNamed(context, VerifyEmailPage.routeName,
                arguments: emailController.text.trim());
          } else {
            ShowSnackBar(context, error, bgColor: Constants.errorColor);
          }
        }
      } catch (_) {
        ShowSnackBar(context, local.unexpectedError, bgColor: Constants.errorColor);
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsets.all(15.w),
          child: ListView(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.h),
                    Center(
                      child: Text(
                        local.signInTitle,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Center(
                      child: Text(
                        local.signInSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFA3A3A3),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    Text(local.email, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
                    SizedBox(height: 15.h),
                    CustomTextFormField(
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) return local.emailRequired;
                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                          return local.emailInvalid;
                        }
                        return null;
                      },
                      hintText: local.enterYourEmail,
                      my_controller: emailController,
                    ),

                    SizedBox(height: 20.h),
                    Text(local.password, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
                    SizedBox(height: 5.h),
                    CustomTextFormField(
                      icon: Icons.lock,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return local.passwordRequired;
                        if (value.length < 8) return local.passwordTooShort;
                        if (!RegExp(r'[A-Z]').hasMatch(value)) return local.passwordUppercase;
                        if (!RegExp(r'[a-z]').hasMatch(value)) return local.passwordLowercase;
                        if (!RegExp(r'[0-9]').hasMatch(value)) return local.passwordNumber;
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return local.passwordSpecial;
                        return null;
                      },
                      hintText: local.enterYourEmail,
                      my_controller: passwordController,
                    ),
                    SizedBox(height: 10.h),

                    Container(
                      margin: EdgeInsets.only(top: 10.h, bottom: 20.h),
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          if (emailController.text.isEmpty) {
                            ShowSnackBar(context, local.pleaseEnterYourEmail,
                                bgColor: Constants.errorColor);
                          } else {
                            Navigator.pushNamed(context, ForgetPassword.routeName,
                                arguments: emailController.text.trim());
                          }
                        },
                        child: Text(
                          local.forgotPassword,
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    CustomButton(title: local.login, onPressed: loginUser),
                    SizedBox(height: 15.h),

                    Center(
                        child: Text(
                          local.orContinueWith,
                          style: TextStyle(
                              color: const Color(0xffA3A3A3),
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp),
                        )),
                    SizedBox(height: 20.h),

                    MaterialButton(
                      height: 50.h,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          side: const BorderSide(color: Color(0xFF572121))),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/google.png', width: 30.w),
                          SizedBox(width: 10.w),
                          Text(
                            local.signInWithGoogle,
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        await GoogleAuthService.signInWithGoogle(context);
                      },
                    ),
                    SizedBox(height: 30.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            local.noAccount,
                            style: TextStyle(
                                color: const Color(0xffA3A3A3),
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, RegisterPage.routeName),
                          child: Text(
                            local.signUp,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
