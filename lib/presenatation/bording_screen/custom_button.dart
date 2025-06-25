import 'package:final2/presenatation/bording_screen/segmented_circular_progress_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../auth/Auth/Login/login.dart';
import '../auth/Auth/auth_service..dart';
import '../auth/Auth/sharedPrefrence/shared_pref.dart';
import '../layout/home_layout.dart';

class CustomNextButton extends StatelessWidget {
  final PageController controller;
  final int page;
  final int totalPages;
  final Function(bool) showAnimatedContainerCallBack;

  CustomNextButton({
    required this.controller,
    required this.page,
    required this.totalPages,
    required this.showAnimatedContainerCallBack,
  });

  Future<void> _checkAutoLogin(BuildContext context) async {
    try {
      final credentials = await SharedPreference.getLoginCredentials();
      final email = credentials['email'];
      final password = credentials['password'];

      if (email != null && password != null) {
        final response = await AuthService.login(
          email: email,
          password: password,
        );

        if (response != null &&
            response.containsKey('success') &&
            response['success'] == true) {
          if (response.containsKey('token')) {
            await SharedPreference.saveToken(response['token']);
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed(HomeLayout.routeName);
              return;
            }
          }
        }
      }
      // If auto-login fails or no credentials, go to login page
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      }
    } catch (e) {
      print('Auto-login failed: $e');
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = 15.w;

    return Container(
      width: defaultSize * 5,
      height: defaultSize * 5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(defaultSize * 5, defaultSize * 5),
            painter: SegmentedCircularProgressPainter(
              progress: (page + 1) / (totalPages + 1),
              color: Theme.of(context).primaryColor,
              strokeWidth: 4.w,
              segments: totalPages,
            ),
          ),
          Center(
            child: InkWell(
              onTap: () async {
                if (page == totalPages - 1) {
                  // On last page, attempt auto-login first
                  await _checkAutoLogin(context);
                } else {
                  controller.animateToPage(
                    page + 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutCirc,
                  );
                  showAnimatedContainerCallBack(false);
                }
              },
              child: Container(
                width: defaultSize * 3.5,
                height: defaultSize * 3.5,
                decoration: BoxDecoration(
                  color:Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(100.r)),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}