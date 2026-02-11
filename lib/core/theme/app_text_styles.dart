import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/theme/app_colors.dart';

class AppTextStyles {
  static const String arabicFont = 'Cairo';
  static const String englishFont = 'Poppins';

  static TextStyle headingLarge({required bool isArabic}) => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: AppColors.textPrimary,
        letterSpacing: isArabic ? 0 : 0.5,
      );

  static TextStyle headingMedium({required bool isArabic}) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: AppColors.textPrimary,
        letterSpacing: isArabic ? 0 : 0.3,
      );

  static TextStyle headingSmall({required bool isArabic}) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: AppColors.textPrimary,
        letterSpacing: isArabic ? 0 : 0.2,
      );

  static TextStyle bodyLarge({required bool isArabic}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: AppColors.textPrimary,
        letterSpacing: isArabic ? 0 : 0.1,
      );

  static TextStyle bodyMedium({required bool isArabic}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: AppColors.textSecondary,
        letterSpacing: isArabic ? 0 : 0.1,
      );

  static TextStyle bodySmall({required bool isArabic}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: AppColors.textSecondary,
      );

  static TextStyle buttonLarge({required bool isArabic}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: Colors.white,
        letterSpacing: isArabic ? 0 : 0.5,
      );

  static TextStyle buttonMedium({required bool isArabic}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: Colors.white,
        letterSpacing: isArabic ? 0 : 0.3,
      );

  static TextStyle label({required bool isArabic}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: AppColors.textSecondary,
      );

  static TextStyle error({required bool isArabic}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: AppColors.error,
      );

  static TextStyle success({required bool isArabic}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: isArabic ? arabicFont : englishFont,
        color: AppColors.success,
      );
}
