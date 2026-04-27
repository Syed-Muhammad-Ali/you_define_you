import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.black,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.orange,
      surface: AppColors.black,
      onPrimary: AppColors.white,
      onSurface: AppColors.white,
    ),
    textTheme: GoogleFonts.dmSansTextTheme().apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLight,
      hintStyle: GoogleFonts.dmSans(
        color: AppColors.deepDimText,
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.orangeGlowStrong),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
  );

  static TextStyle bebas({
    double size = 24,
    Color color = AppColors.white,
    double height = 1,
    double letterSpacing = 1,
  }) {
    return GoogleFonts.bebasNeue(
      fontSize: size,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle body({
    double size = 14,
    Color color = AppColors.muted,
    FontWeight weight = FontWeight.w300,
    double height = 1.6,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.dmSans(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
      fontStyle: fontStyle,
    );
  }
}
