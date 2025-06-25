import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      print('🔵 بدء تسجيل الدخول باستخدام Google...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('❌ المستخدم ألغى تسجيل الدخول.');
        return;
      }

      print('✅ تم اختيار حساب Google: ${googleUser.email}');

      final Uri url = Uri.parse('https://green-world-vert.vercel.app/auth/google');

      if (await canLaunchUrl(url)) {
        print('🌍 جاري توجيه المستخدم إلى صفحة تسجيل الدخول...');
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw '🚨 Could not launch $url';
      }
    } catch (error) {
      print('❌ خطأ أثناء تسجيل الدخول: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تسجيل الدخول: $error')),
      );
    }
  }
}
