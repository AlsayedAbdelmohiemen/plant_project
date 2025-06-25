// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:google_test/Auth/sharedPrefrence/shared_pref.dart';
//
// class NotificationPage extends StatefulWidget {
//   static const String routeName = 'NotificationPage';
//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//   String _token = 'جارِ تحميل التوكن...';
//
//   @override
//   void initState() {
//     super.initState();
//     _getToken();
//
//     // متابعة تغيّر التوكن وإعادة إرساله
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       print('تم تحديث FCM Token: $newToken');
//       _sendFcmTokenToBackend(newToken);
//     });
//   }
//
//   /// استدعاء توكن FCM وإرساله للسيرفر
//   Future<void> _getToken() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     await messaging.requestPermission();
//
//     String? token = await messaging.getToken();
//     print('FCM Token: $token');
//
//     if (token != null) {
//       await _sendFcmTokenToBackend(token);
//     }
//
//     setState(() {
//       _token = token ?? 'فشل في الحصول على التوكن';
//     });
//   }
//
//   /// إرسال FCM Token للباك اند
//   Future<void> _sendFcmTokenToBackend(String fcmToken) async {
//     final userToken = await SharedPrefrence.getToken();
//
//     if (userToken == null) {
//       print('لا يوجد User Token محفوظ');
//       return;
//     }
//
//     final url = Uri.parse('https://green-world-vert.vercel.app/auth/update-fcm');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'token': userToken,
//       },
//       body: jsonEncode({
//         'fcmToken': fcmToken,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       print('تم إرسال FCM Token بنجاح');
//     } else {
//       print('فشل في إرسال FCM Token: ${response.statusCode}');
//       print(response.body);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('عرض التوكن')),
//       body: Center(
//         child: SelectableText(_token),
//       ),
//     );
//   }
// }
