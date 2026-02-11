import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_app/core/constants/app_constants.dart';
import 'package:pharmacy_app/core/theme/app_theme.dart';
import 'package:pharmacy_app/presentation/pages/splash_page.dart';
import 'package:pharmacy_app/presentation/pages/welcome_page.dart';
import 'package:pharmacy_app/presentation/pages/login_page.dart';
import 'package:pharmacy_app/presentation/pages/register_page.dart';
import 'package:pharmacy_app/presentation/pages/forgot_password_page.dart';
import 'package:pharmacy_app/presentation/pages/home_page.dart';
import 'package:pharmacy_app/presentation/pages/orders_page.dart';
import 'package:pharmacy_app/presentation/providers/auth_provider.dart';
import 'package:pharmacy_app/presentation/providers/language_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const PharmacyApp(),
    ),
  );
}

class PharmacyApp extends StatefulWidget {
  const PharmacyApp({super.key});

  @override
  State<PharmacyApp> createState() => _PharmacyAppState();
}

class _PharmacyAppState extends State<PharmacyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final isArabic = languageProvider.isArabic;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          locale: languageProvider.locale,
          supportedLocales: AppConstants.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return AppConstants.englishLocale;
          },
          theme: AppTheme.lightTheme(isArabic),
          initialRoute: AppConstants.splashRoute,
          routes: {
            AppConstants.splashRoute: (context) => const SplashPage(),
            AppConstants.welcomeRoute: (context) => const WelcomePage(),
            AppConstants.loginRoute: (context) => const LoginPage(),
            AppConstants.registerRoute: (context) => const RegisterPage(),
            AppConstants.forgotPasswordRoute: (context) =>
                const ForgotPasswordPage(),
            AppConstants.homeRoute: (context) => const HomePage(),
            AppConstants.ordersRoute: (context) => const OrdersPage(),
          },
          onGenerateRoute: (settings) {
            return null;
          },
        );
      },
    );
  }
}
