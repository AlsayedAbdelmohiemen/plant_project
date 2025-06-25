import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(local.security),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Section(
              title: local.securityCommitment,
              content: local.securityCommitmentContent,
            ),
            Section(
              title: local.securitySignup,
              content: local.securitySignupContent,
            ),
            Section(
              title: local.securityLogin,
              content: local.securityLoginContent,
            ),
            Section(
              title: local.securityRecovery,
              content: local.securityRecoveryContent,
            ),
            Section(
              title: local.securityReset,
              content: local.securityResetContent,
            ),
            Section(
              title: local.securityEncryption,
              content: local.securityEncryptionContent,
            ),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String content;

  const Section({required this.title, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 8.h),
          Text(content,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
