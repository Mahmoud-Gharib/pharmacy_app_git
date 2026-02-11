import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/constants/app_constants.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = AppConstants.englishLocale;

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      _locale = AppConstants.arabicLocale;
    } else {
      _locale = AppConstants.englishLocale;
    }
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
