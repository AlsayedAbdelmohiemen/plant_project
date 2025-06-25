import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/theme_cubit/theme_cubit.dart';
import '../../business_logic/localization/localiz.dart';
import '../model/AI_model/AI_model/prediction_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final languageCubit = context.watch<LanguageCubit>();
    final isDark = themeCubit.isDarkMode;
    final currentLocale = languageCubit.currentLocale;
    final localizations = AppLocalizations.of(context)!;

    bool isArabic = currentLocale.languageCode == 'ar';
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Switch
          Card(
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: Text(
                localizations.darkTheme,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: isDark,
              activeColor: primaryColor,
              onChanged: (_) => themeCubit.toggleTheme(),
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: primaryColor,
              ),
            ),
          ),

          // Language Switch
          Card(
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: Text(
                localizations.language,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                isArabic ? localizations.arabic : localizations.english,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: isArabic,
              activeColor: primaryColor, // ✅ زر السويتش بلون الـ primary
              // Inside the language SwitchListTile's onChanged:
              onChanged: (value) {
                final newLocale = value ? const Locale('ar') : const Locale('en');
                languageCubit.changeLanguage(newLocale);

                // Update the PredictionProvider's language
                final predictionProvider = Provider.of<PredictionProvider>(context, listen: false);
                predictionProvider.setLanguage(newLocale.languageCode);
              },
              secondary: Icon(Icons.language, color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
