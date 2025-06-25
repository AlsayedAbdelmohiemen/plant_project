import 'package:final2/presenatation/auth/Auth/sharedPrefrence/shared_pref.dart';
import 'package:flutter/material.dart';

import '../../layout/home_layout.dart';
import 'Login/login.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SharedPreference.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return HomeLayout();
        } else {
          return LoginPage();
        }
      },
    );
  }
}