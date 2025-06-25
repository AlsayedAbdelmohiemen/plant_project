// lib/notifications/notification_service.dart
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../../../auth/Auth/sharedPrefrence/shared_pref.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );


    // الحصول على التوكن الحالي
    final token = await _messaging.getToken();
    if (token != null) {
      await sendFcmTokenToBackend(token);
    }

    // استماع لتغيّر التوكن وإرساله
    _messaging.onTokenRefresh.listen((newToken) {
      print('🔁 FCM Token تم تغييره: $newToken');
      sendFcmTokenToBackend(newToken);
    });
  }

  Future<void> sendFcmTokenToBackend(String fcmToken) async {
    final userToken = await SharedPreference.getToken();
    if (userToken == null) {
      print('❌ لا يوجد User Token');
      return;
    }

    final url =
        Uri.parse('https://green-world-vert.vercel.app/auth/update-fcm');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': userToken,
      },
      body: jsonEncode({'fcmToken': fcmToken}),
    );

    if (response.statusCode == 200) {
      print('✅ FCM Token تم إرساله بنجاح');
    } else {
      print('❌ فشل إرسال FCM Token: ${response.statusCode}');
    }
  }
}
