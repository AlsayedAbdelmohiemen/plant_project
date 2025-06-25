import 'package:device_preview/device_preview.dart';
import 'package:final2/presenatation/auth/Auth/Login/login.dart';
import 'package:final2/presenatation/auth/Auth/Register/register.dart';
import 'package:final2/presenatation/auth/Auth/Register/verify_email_page.dart';
import 'package:final2/presenatation/auth/Auth/forget_password/forget_password.dart';
import 'package:final2/presenatation/auth/Auth/forget_password/opt_page.dart';
import 'package:final2/presenatation/auth/Auth/forget_password/reset_password_page.dart';
import 'package:final2/presenatation/bording_screen/page_view.dart';
import 'package:final2/presenatation/bording_screen/presentation_components.dart';
import 'package:final2/presenatation/layout/home_layout.dart';
import 'package:final2/presenatation/model/AI_model/AI_model/prediction_provider.dart';
import 'package:final2/presenatation/settings/Notification/Notification/notification_handler.dart';
import 'package:final2/presenatation/settings/Notification/Notification/notification_service.dart';
import 'package:final2/presenatation/splash/Splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sha_fingerprint/flutter_sha_fingerprint.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'business_logic/image_cubit/image_profile_cubit.dart';
import 'business_logic/localization/localiz.dart';
import 'business_logic/profile_cubit/profile_cubit.dart';
import 'business_logic/theme_cubit/theme_cubit.dart';
import 'business_logic/cubit/plants_cubit.dart';
import 'constants/utils/theme.dart';
import 'data/repository/plants_repository.dart';
import 'data/repository/profile_repository.dart';
import 'data/repository/profile_repository_image.dart';
import 'data/web_service/plants_web_service.dart';
import 'data/web_service/profile_web_service.dart';
import 'data/web_service/profile_web_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    await NotificationHandler.init();
    await NotificationService().initFCM();
    final sha1 = await FlutterShaFingerprint.getFingerprints();
  } catch (e) {
    debugPrint('Error during initialization: $e');
  }

  runApp(
    DevicePreview(
      enabled: !const bool.fromEnvironment('dart.vm.product'),
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PlantsRepository plantsRepository = PlantsRepository(PlantWebServices());
  final ProfileRepository profileRepository = ProfileRepository(ProfileWebServices());
  final ProfileRepositoryImage profileRepositoryImage = ProfileRepositoryImage(ProfileWebServiceImage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PredictionProvider()),
        BlocProvider(create: (context) => PlantsCubit(plantsRepository)),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => ProfileCubit(profileRepository)..fetchProfile()),
        BlocProvider<ProfileImageCubit>(create: (context) => ProfileImageCubit(profileRepositoryImage)),
        BlocProvider(create: (context) => LanguageCubit()..loadSavedLanguage()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, theme) {
              return BlocBuilder<LanguageCubit, Locale>(
                builder: (context, locale) {
                  return MaterialApp(
                    title: 'Plants App',
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: theme == AppTheme.darkTheme ? ThemeMode.dark : ThemeMode.light,
                    locale: locale,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('en'),
                      Locale('ar'),
                    ],

                    builder: DevicePreview.appBuilder,

                    onGenerateRoute: (settings) {
                      switch (settings.name) {
                        case VerifyEmailPage.routeName:
                          final String email = settings.arguments as String;
                          return MaterialPageRoute(
                            builder: (context) => VerifyEmailPage(email: email),
                          );
                        default:
                          return null;
                      }
                    },

                    initialRoute: SplashScreen.routeName,
                    routes: {
                      SplashScreen.routeName: (context) => const SplashScreen(),
                      HomeLayout.routeName: (context) => HomeLayout(),
                      OnboardingPageView.routeName: (context) => const PresentationComponents(),
                      LoginPage.routeName: (context) => LoginPage(),
                      RegisterPage.routeName: (context) => RegisterPage(),
                      ForgetPassword.routeName: (context) => ForgetPassword(),
                      ResetPasswordPage.routeName: (context) => ResetPasswordPage(),
                      OtpPage.routeName: (context) => OtpPage(),
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
