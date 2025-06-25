import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constant..dart';
import '../../helper/show_snack_bar.dart';
import '../auth_service..dart';
import '../components/custom_bottom.dart';
import '../components/text_form_filed.dart';
import '../login/deep_link_service.dart';
import '../login/google_auth_service.dart';
import '../login/login.dart';
import '../sharedPrefrence/shared_pref.dart';
import 'verify_email_page.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = 'RegisterPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    DeepLinkService.initDeepLinkListener(context);
  }

  @override
  void dispose() {
    DeepLinkService.disposeDeepLinkListener();
    userName.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void registerUser() async {
    final local = AppLocalizations.of(context)!;

    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final response = await AuthService.signup(
          userName: userName.text.trim(),
          email: email.text.trim(),
          password: password.text.trim(),
        );

        if (response != null &&
            response.containsKey('success') &&
            response['success'] == true) {
          if (response.containsKey('token')) {
            await SharedPreference.saveToken(response['token']);
          }

          ShowSnackBar(context, local.signupSuccess, bgColor: Constants.successColor);
          await Future.delayed(Duration(milliseconds: 1500));
          Navigator.pushNamed(
            context,
            VerifyEmailPage.routeName,
            arguments: email.text.trim(),
          );
        } else {
          String errorMessage = response?['message'] ?? local.signupFailed;
          ShowSnackBar(context, errorMessage, bgColor: Constants.errorColor);
        }
      } catch (e) {
        ShowSnackBar(context, local.unexpectedError, bgColor: Constants.errorColor);
      } finally {
        setState(() => isLoading = false);
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
                    SizedBox(height: 40.h),
                    Center(
                      child: Text(
                        local.createAccount,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Center(
                      child: Text(
                        local.createAccountSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFA3A3A3),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Username
                    Text(local.username,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
                    SizedBox(height: 5.h),
                    CustomTextFormField(
                      icon: Icons.person,
                      hintText: local.username,
                      validator: (value) => value!.isEmpty ? local.usernameRequired : null,
                      my_controller: userName,
                    ),

                    SizedBox(height: 15.h),

                    // Email
                    Text(local.email,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
                    SizedBox(height: 15.h),
                    CustomTextFormField(
                      icon: Icons.email,
                      hintText: local.enterYourEmail,
                      validator: (value) {
                        if (value == null || value.isEmpty) return local.emailRequired;
                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                            .hasMatch(value)) {
                          return local.emailInvalid;
                        }
                        return null;
                      },
                      my_controller: email,
                    ),

                    SizedBox(height: 15.h),

                    // Password
                    Text(local.password,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
                    CustomTextFormField(
                      icon: Icons.lock,
                      hintText: local.password,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return local.passwordRequired;
                        if (value.length < 8) return local.passwordTooShort;
                        if (!RegExp(r'[A-Z]').hasMatch(value)) return local.passwordUppercase;
                        if (!RegExp(r'[a-z]').hasMatch(value)) return local.passwordLowercase;
                        if (!RegExp(r'[0-9]').hasMatch(value)) return local.passwordNumber;
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return local.passwordSpecial;
                        }
                        return null;
                      },
                      my_controller: password,
                    ),

                    SizedBox(height: 40.h),

                    CustomButton(title: local.signUp, onPressed: registerUser),

                    SizedBox(height: 30.h),
                    MaterialButton(
                      height: 50.h,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: const BorderSide(color: Color(0xFF572121)),
                      ),
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
                              color: Colors.black,
                            ),
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
                        Text(
                          local.alreadyHaveAccount,
                          style: TextStyle(
                            color: const Color(0xffA3A3A3),
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, LoginPage.routeName);
                          },
                          child: Text(
                            local.login,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
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
