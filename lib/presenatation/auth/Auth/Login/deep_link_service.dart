import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import '../../../layout/home_layout.dart';
import '../../helper/show_snack_bar.dart';
import '../sharedPrefrence/shared_pref.dart';

class DeepLinkService {
  static StreamSubscription? _deepLinkSubscription;
  static late AppLinks _appLinks;

  static void initDeepLinkListener(BuildContext context) async {
    _appLinks = AppLinks();
    _deepLinkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      if (uri.queryParameters.containsKey('token')) {
        final String token = uri.queryParameters['token']!;
        print('🔵 تم استقبال الـ token: $token');

        SharedPreference.saveToken(token).then((_) {
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeLayout()),
            );
            ShowSnackBar(context, "Login successful", bgColor: Colors.green);
          }
        });
      }
    }, onError: (error) {
      print('❌ خطأ أثناء استقبال الـ Deep Link: $error');
      ShowSnackBar(context, 'An error occurred during login: $error', bgColor: Colors.red);
    });
  }

  static void disposeDeepLinkListener() {
    _deepLinkSubscription?.cancel();
  }
}