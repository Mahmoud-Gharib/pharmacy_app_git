import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Pharmacy Pro';
  static const String appVersion = '1.0.0';

  // Routes
  static const String splashRoute = '/';
  static const String welcomeRoute = '/welcome';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String verifyPinRoute = '/verify-pin';
  static const String resetPasswordRoute = '/reset-password';
  static const String homeRoute = '/home';
  static const String ordersRoute = '/orders';

  // Shared Preferences Keys
  static const String languageKey = 'language';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String userTokenKey = 'userToken';

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int itemsPerPage = 20;

  // UI Constants
  static const double defaultPadding = 24.0;
  static const double smallPadding = 16.0;
  static const double largePadding = 32.0;
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double cardElevation = 4.0;

  // Languages
  static const Locale arabicLocale = Locale('ar', '');
  static const Locale englishLocale = Locale('en', '');
  static const List<Locale> supportedLocales = [arabicLocale, englishLocale];
}
