/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/responsive_helper/responsive_helper.dart';
import '../../utils/color/app_colors.dart';

*/
/*

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.bgColor,

  /// ✅ GLOBAL TEXT THEME (ONE SOURCE OF TRUTH)
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    titleLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryColor,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 24,
      //fontSize: ResponsiveHelper.fontSize(24),
      fontWeight: FontWeight.w600,
      color: AppColors.primaryColor,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryColor,
    ),
    bodyMedium: GoogleFonts.poppins(
      //fontSize: 14,
      fontSize: ResponsiveHelper.fontSize(14),
      fontWeight: FontWeight.w600,
      color: AppColors.white,
     ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.text2,
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryColor,
    ),
  ),

  /// ✅ APP BAR (NO textTheme here)
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.bgColor,
    elevation: 0,
    centerTitle: true,
    *//*

*/
/*iconTheme: const IconThemeData(
      color: AppColors.white,
    ),*//*
*/
/*

    titleTextStyle: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryColor,
    ),
  ),
  /// BUTTONS
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.brandHoverColor,
      foregroundColor: AppColors.text2,
      minimumSize: const Size(186, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: AppColors.brandHoverColor,
        width: 1.5,
      ),
      minimumSize: const Size(186, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryText,
      textStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
    ),
  ),

  /// INPUTS
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.softBrandColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: GoogleFonts.poppins(
      fontSize: 14,
      color: AppColors.secondaryText,
    ),
    errorStyle: GoogleFonts.poppins(
      fontSize: 12,
      color: AppColors.errorColor,
    ),
  ),
);
*//*




ThemeData lightTheme(BuildContext context) {
  // ResponsiveHelper is already initialized when this runs
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgColor,

    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      titleLarge: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(32), // ✅ Safe now
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(24), // ✅ Safe now
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(14), // ✅ Safe now
        fontWeight: FontWeight.w400,
        color: AppColors.primaryColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(14), // ✅ Safe now
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(12), // ✅ Safe now
        fontWeight: FontWeight.w400,
        color: AppColors.text2,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(12), // ✅ Safe now
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColor,
      ),
    ),
    // ... rest of your theme unchanged


  );
}*/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/responsive_helper/responsive_helper.dart';
import '../../utils/color/app_colors.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgColor,

    // ✅ Text Selection Theme
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: AppColors.primaryColor.withOpacity(0.3),
      selectionHandleColor: AppColors.primaryColor,
    ),

    /// GLOBAL TEXT THEME
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      titleLarge: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(32),
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(24),
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(14),
        fontWeight: FontWeight.w400,
        color: AppColors.primaryColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(14),
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(12),
        fontWeight: FontWeight.w400,
        color: AppColors.text2,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(12),
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColor,
      ),
    ),

    /// APP BAR
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(12),
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColor,
      ),
    ),

    /// BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandHoverColor,
        foregroundColor: AppColors.text2,
        minimumSize: const Size(186, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: ResponsiveHelper.fontSize(16),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: AppColors.brandHoverColor,
          width: 1.5,
        ),
        minimumSize: const Size(186, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: ResponsiveHelper.fontSize(16),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryText,
        textStyle: GoogleFonts.poppins(
          fontSize: ResponsiveHelper.fontSize(14),
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    ),

    /// INPUTS
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.softBrandColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(14),
        color: AppColors.secondaryText,
      ),
      errorStyle: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(12),
        color: AppColors.errorColor,
      ),
    ),
  );
}