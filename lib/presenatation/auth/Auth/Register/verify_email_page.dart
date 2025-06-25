import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constant..dart';
import '../components/custom_bottom.dart';
import '../login/login.dart';

class VerifyEmailPage extends StatelessWidget {
  static const routeName = 'VerifyEmailPage';
  final String email;

  const VerifyEmailPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  local.verifyYourEmail,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w700,
                    color: Constants.greenColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.h),

            Icon(
              Icons.mark_email_read_outlined,
              size: 80.w,
              color: const Color(0xff335540),
            ),
            SizedBox(height: 20.h),

            Text(
              local.verificationLinkSentTo,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff335540),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),

            Text(
              email,
              style: TextStyle(
                fontSize: 17.sp,
                color: const Color(0xff335540),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40.h),

            Text(
              '"${local.checkEmailMessage}"',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff040419),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 80.h),

            CustomButton(
              title: local.goToLogin,
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
