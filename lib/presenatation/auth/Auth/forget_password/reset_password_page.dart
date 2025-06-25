import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../layout/home_layout.dart';
import '../../constant..dart';
import '../../helper/show_snack_bar.dart';
import '../auth_service..dart';
import '../components/custom_bottom.dart';
import '../components/text_form_filed.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routeName = 'resetPassword';

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  void resetPassword() async {
    final local = AppLocalizations.of(context)!;

    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final email = ModalRoute.of(context)!.settings.arguments as String;
      final newPassword = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      try {
        final response = await AuthService.resetPassword(
          email,
          newPassword,
          confirmPassword,
        );

        if (response['success'] == true) {
          ShowSnackBar(context, local.resetPasswordSuccess, bgColor: Constants.successColor);
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeLayout.routeName,
                (route) => false,
          );
        } else {
          ShowSnackBar(context, local.resetPasswordFailed, bgColor: Constants.errorColor);
        }
      } catch (e) {
        ShowSnackBar(context, "${local.errorOccurred}: $e", bgColor: Constants.errorColor);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

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
                SizedBox(height: 60.h),
                Text(
                  local.resetPasswordTitle,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  local.resetPasswordMessage,
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
                SizedBox(height: 50.h),

                Text(
                  local.createNewPassword,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  icon: Icons.lock,
                  hintText: local.enterNewPassword,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return local.passwordRequired;
                    }
                    if (value.length < 6) {
                      return local.passwordTooShort;
                    }
                    return null;
                  },
                  my_controller: passwordController,
                ),
                SizedBox(height: 30.h),

                Text(
                  local.confirmNewPassword,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  icon: Icons.lock,
                  hintText: local.confirmNewPassword,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return local.confirmPasswordRequired;
                    }
                    if (value != passwordController.text) {
                      return local.passwordsDoNotMatch;
                    }
                    return null;
                  },
                  my_controller: confirmPasswordController,
                ),
                SizedBox(height: 40.h),

                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                  title: local.resetPasswordButton,
                  onPressed: resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
