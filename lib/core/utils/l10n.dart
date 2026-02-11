import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/constants/app_constants.dart';

class L10n {
  static const List<Locale> supportedLocales = AppConstants.supportedLocales;
  
  static Locale getLocale(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return AppConstants.arabicLocale;
      case 'en':
      default:
        return AppConstants.englishLocale;
    }
  }
  
  static bool isRtl(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }
  
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'English';
    }
  }
}
